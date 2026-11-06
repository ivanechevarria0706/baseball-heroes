"""Invite-group leagues. Persistent schedule; standings derived from final games."""
from fractions import Fraction
import json
import secrets
import time
import rules

SCHEMA = """
CREATE TABLE IF NOT EXISTS leagues(id TEXT PRIMARY KEY, owner_id TEXT NOT NULL REFERENCES users(id), name TEXT NOT NULL, status TEXT NOT NULL, created REAL NOT NULL);
CREATE TABLE IF NOT EXISTS league_members(league_id TEXT NOT NULL REFERENCES leagues(id), user_id TEXT NOT NULL REFERENCES users(id), joined REAL NOT NULL, snapshot TEXT, PRIMARY KEY(league_id,user_id));
CREATE TABLE IF NOT EXISTS fixtures(id TEXT PRIMARY KEY, league_id TEXT NOT NULL REFERENCES leagues(id), round INTEGER NOT NULL, home_id TEXT NOT NULL, away_id TEXT NOT NULL, match_id TEXT UNIQUE REFERENCES matches(id), UNIQUE(league_id,home_id,away_id), FOREIGN KEY(league_id,home_id) REFERENCES league_members(league_id,user_id), FOREIGN KEY(league_id,away_id) REFERENCES league_members(league_id,user_id));
CREATE INDEX IF NOT EXISTS fixture_league ON fixtures(league_id,round);
"""


def schedule(ids):
    """Circle schedule: every ordered pair once; odd groups receive byes."""
    circle = list(ids)
    if len(circle) % 2:
        circle.append(None)
    first = []
    rounds = len(circle)-1
    for round_index in range(rounds):
        for i in range(len(circle)//2):
            a, b = circle[i], circle[-1-i]
            if a is None or b is None:
                continue
            if (round_index+i) % 2:
                a, b = b, a
            first.append((round_index+1, a, b))
        circle = [circle[0], circle[-1]]+circle[1:-1]
    return first+[(r+rounds, b, a) for r, a, b in first]


def standings(members, fixtures):
    rows = {m["id"]: {"id": m["id"], "name": m["name"], "teamName": m["teamName"],
                       "played": 0, "wins": 0, "losses": 0, "ties": 0, "runsFor": 0, "runsAgainst": 0}
            for m in members}
    for f in fixtures:
        if f["status"] != "complete":
            continue
        for side, other in (("home", "away"), ("away", "home")):
            row = rows[f[side+"Id"]]
            row["played"] += 1
            row["runsFor"] += f[side]
            row["runsAgainst"] += f[other]
            row["wins" if f[side] > f[other] else "losses" if f[side] < f[other] else "ties"] += 1
    def key(row):
        return (Fraction(2*row["wins"]+row["ties"], 2*row["played"]) if row["played"] else Fraction(0),
                row["runsFor"]-row["runsAgainst"], row["runsFor"])
    ordered = sorted(rows.values(), key=lambda r: r["teamName"].casefold())
    ordered.sort(key=key, reverse=True)
    previous, position = None, 0
    for i, row in enumerate(ordered):
        metric = key(row)
        if metric != previous:
            position = i+1
        row["rank"] = position
        row["pct"] = format(float(metric[0]), ".3f") if row["played"] else "—"
        row["differential"] = metric[1]
        previous = metric
    return ordered


class Leagues:
    def __init__(self, service, fail, text_value):
        self.service, self.fail, self.text = service, fail, text_value

    def get(self, db, lid):
        row = db.execute("SELECT * FROM leagues WHERE id=?", (lid,)).fetchone()
        if not row:
            self.fail(404, "League unavailable.")
        return dict(row)

    def member(self, db, lid, uid):
        return db.execute("SELECT 1 FROM league_members WHERE league_id=? AND user_id=?", (lid, uid)).fetchone() is not None

    def listing(self, db, uid):
        result = []
        for row in db.execute("SELECT * FROM leagues WHERE status='open' OR id IN (SELECT league_id FROM league_members WHERE user_id=?) ORDER BY created DESC LIMIT 50", (uid,)):
            league = dict(row)
            result.append({"id": league["id"], "name": league["name"], "status": league["status"],
                           "ownerId": league["owner_id"], "joined": self.member(db, league["id"], uid),
                           "count": db.execute("SELECT COUNT(*) FROM league_members WHERE league_id=?", (league["id"],)).fetchone()[0]})
        return {"leagues": result, "maxPlayers": 8}

    def detail(self, db, lid, uid):
        league = self.get(db, lid)
        if not self.member(db, lid, uid):
            self.fail(404, "Join the league to view its games.")
        members = []
        for row in db.execute("SELECT lm.*,u.name,t.data FROM league_members lm JOIN users u ON u.id=lm.user_id LEFT JOIN teams t ON t.user_id=u.id WHERE lm.league_id=? ORDER BY lm.joined,lm.user_id", (lid,)):
            team = json.loads(row["snapshot"] or row["data"]) if row["snapshot"] or row["data"] else None
            members.append({"id": row["user_id"], "name": row["name"], "teamName": team["name"] if team else "No team",
                            "teamVersion": team["version"] if team else None})
        fixtures = []
        for row in db.execute("SELECT f.*,m.state FROM fixtures f LEFT JOIN matches m ON m.id=f.match_id WHERE f.league_id=? ORDER BY f.round,f.id", (lid,)):
            state = json.loads(row["state"]) if row["state"] else None
            fixtures.append({"id": row["id"], "round": row["round"], "homeId": row["home_id"], "awayId": row["away_id"],
                             "matchId": row["match_id"], "status": state["status"] if state else "scheduled",
                             "home": state["home"] if state else None, "away": state["away"] if state else None,
                             "forfeit": bool(state and state.get("forfeit"))})
        table = standings(members, fixtures)
        return {"id": lid, "name": league["name"], "ownerId": league["owner_id"], "status": league["status"],
                "members": members, "fixtures": fixtures, "standings": table,
                "completed": sum(f["status"] == "complete" for f in fixtures),
                "rounds": max((f["round"] for f in fixtures), default=0),
                "champions": [r["id"] for r in table if r["rank"] == 1] if league["status"] == "complete" else []}

    def create(self, db, uid, data):
        if not db.execute("SELECT 1 FROM teams WHERE user_id=?", (uid,)).fetchone():
            self.fail(409, "Publish your team before creating a league.")
        if db.execute("SELECT 1 FROM leagues WHERE owner_id=? AND status IN ('open','running')", (uid,)).fetchone():
            self.fail(409, "You already organize an open or active league.")
        lid = secrets.token_hex(16)
        name = self.text(data, "name", 3, 36)
        db.execute("INSERT INTO leagues VALUES(?,?,?,?,?)", (lid, uid, name, "open", time.time()))
        db.execute("INSERT INTO league_members VALUES(?,?,?,NULL)", (lid, uid, time.time()))
        return self.detail(db, lid, uid)

    def change(self, db, lid, uid, action):
        league = self.get(db, lid)
        if league["status"] != "open":
            self.fail(409, "Registration is closed. Lineups are already fixed.")
        if action == "join":
            if self.member(db, lid, uid):
                return self.detail(db, lid, uid)
            if db.execute("SELECT COUNT(*) FROM league_members WHERE league_id=?", (lid,)).fetchone()[0] >= 8:
                self.fail(409, "The league already has eight teams.")
            if not db.execute("SELECT 1 FROM teams WHERE user_id=?", (uid,)).fetchone():
                self.fail(409, "Publish your team before joining.")
            db.execute("INSERT INTO league_members VALUES(?,?,?,NULL)", (lid, uid, time.time()))
            return self.detail(db, lid, uid)
        if not self.member(db, lid, uid):
            self.fail(404, "You are not a member of this league.")
        if action == "leave":
            if uid == league["owner_id"]:
                self.fail(409, "The organizer can cancel league registration.")
            db.execute("DELETE FROM league_members WHERE league_id=? AND user_id=?", (lid, uid))
            return self.listing(db, uid)
        if uid != league["owner_id"]:
            self.fail(403, "Only the organizer can do this.")
        if action == "cancel":
            db.execute("UPDATE leagues SET status='cancelled' WHERE id=?", (lid,))
            return self.detail(db, lid, uid)
        members = list(db.execute("SELECT lm.user_id,t.data FROM league_members lm LEFT JOIN teams t ON t.user_id=lm.user_id WHERE league_id=? ORDER BY lm.joined,lm.user_id", (lid,)))
        if len(members) < 2 or any(not m["data"] for m in members):
            self.fail(409, "At least two published teams are required.")
        for m in members:
            db.execute("UPDATE league_members SET snapshot=? WHERE league_id=? AND user_id=?", (m["data"], lid, m["user_id"]))
        for round_number, home, away in schedule([m["user_id"] for m in members]):
            db.execute("INSERT INTO fixtures VALUES(?,?,?,?,?,NULL)", (secrets.token_hex(16), lid, round_number, home, away))
        db.execute("UPDATE leagues SET status='running' WHERE id=?", (lid,))
        return self.detail(db, lid, uid)

    def play(self, db, lid, fid, uid):
        league = self.get(db, lid)
        fixture = db.execute("SELECT * FROM fixtures WHERE league_id=? AND id=?", (lid, fid)).fetchone()
        if not self.member(db, lid, uid) or not fixture:
            self.fail(404, "Game unavailable.")
        if fixture["home_id"] != uid:
            self.fail(403, "The home team plays this game.")
        if fixture["match_id"]:
            return self.service.public_match(self.service.match(db, fixture["match_id"], uid), db)
        if league["status"] != "running":
            self.fail(409, "The league is not in progress.")
        self.service.ensure_no_active_match(db, uid)
        home = db.execute("SELECT snapshot FROM league_members WHERE league_id=? AND user_id=?", (lid, uid)).fetchone()[0]
        away = db.execute("SELECT snapshot FROM league_members WHERE league_id=? AND user_id=?", (lid, fixture["away_id"])).fetchone()[0]
        mid = secrets.token_hex(16)
        state = rules.new_state(json.loads(home), json.loads(away))
        db.execute("INSERT INTO matches VALUES(?,?,?,?,?,?,?,?)", (mid, uid, fixture["away_id"], home, away, json.dumps(state), 0, time.time()))
        db.execute("UPDATE fixtures SET match_id=? WHERE id=?", (mid, fid))
        self.finish_if_complete(db, lid)
        return self.service.public_match(self.service.match(db, mid, uid), db)

    def for_match(self, db, mid):
        row = db.execute("SELECT f.league_id,f.round,l.name FROM fixtures f JOIN leagues l ON l.id=f.league_id WHERE f.match_id=?", (mid,)).fetchone()
        return {"id": row["league_id"], "name": row["name"], "round": row["round"]} if row else None

    def finish_if_complete(self, db, lid):
        if not lid:
            return
        rows = list(db.execute("SELECT m.state FROM fixtures f LEFT JOIN matches m ON m.id=f.match_id WHERE f.league_id=?", (lid,)))
        if rows and all(r[0] and json.loads(r[0])["status"] == "complete" for r in rows):
            db.execute("UPDATE leagues SET status='complete' WHERE id=? AND status='running'", (lid,))
