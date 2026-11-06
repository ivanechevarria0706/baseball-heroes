"""Private exhibition rules v1. No writes to the offline season or economy.

The service owns the score and simulation. Reported human swing timing is still
client input, not proof of an unassisted player. These are reconstructed rules.
"""
import copy
import random
import secrets
import time

RULES = "private-exhibition-1"
RNG = random.SystemRandom()


def new_state(home, away):
    state = {"rules": RULES, "status": "playing", "inning": 1, "side": "away",
             "outs": 0, "strikes": 0, "balls": 0, "bases": [None]*3,
             "home": 0, "away": 0, "homeLine": [None]*9, "awayLine": [None]*9,
             "homeIndex": 0, "awayIndex": 0, "pending": None, "events": [], "halfPA": 0,
             "box": {s: [{"name": p["name"], "ab": 0, "h": 0, "hr": 0, "rbi": 0}
                         for p in t["players"]] for s, t in [("home", home), ("away", away)]}}
    advance(state, home, away)
    return state


def cpu_result(player, defense):
    hit = max(.14, min(.48, .27 + (player["contact"] - defense)/600))
    roll = RNG.random()
    if roll < .075:
        return "WALK"
    if roll > .075 + hit:
        return "OUT"
    extra = RNG.random()
    if extra < min(.28, .055 + player["power"]/1000):
        return "HOME RUN"
    return "TRIPLE" if extra < .14 else "DOUBLE" if extra < .40 else "SINGLE"


def apply_pa(s, team, outcome):
    side = s["side"]
    index = s[side + "Index"]
    row = s["box"][side][index]
    runs = 0
    if outcome == "WALK":
        if s["bases"][0] is not None:
            if s["bases"][1] is not None:
                if s["bases"][2] is not None:
                    runs += 1
                s["bases"][2] = s["bases"][1]
            s["bases"][1] = s["bases"][0]
        s["bases"][0] = index
    elif outcome in ("OUT", "STRIKEOUT"):
        s["outs"] += 1
        row["ab"] += 1
    else:
        distance = {"SINGLE": 1, "DOUBLE": 2, "TRIPLE": 3, "HOME RUN": 4}[outcome]
        next_bases = [None]*3
        for base, runner in enumerate(s["bases"]):
            if runner is not None:
                if base + distance >= 3:
                    runs += 1
                else:
                    next_bases[base + distance] = runner
        if distance == 4:
            runs += 1
            row["hr"] += 1
        else:
            next_bases[distance-1] = index
        s["bases"] = next_bases
        row["ab"] += 1
        row["h"] += 1
    row["rbi"] += runs
    s[side] += runs
    line = s[side + "Line"]
    line[s["inning"]-1] = (line[s["inning"]-1] or 0) + runs
    s["events"].append({"inning": s["inning"], "side": side, "player": row["name"],
                        "outcome": outcome, "runs": runs})
    s[side + "Index"] = (index + 1) % 9
    s["balls"] = s["strikes"] = 0
    s["halfPA"] += 1
    if side == "home" and s["inning"] == 9 and s["home"] > s["away"]:
        s["status"] = "complete"


def advance(s, home, away):
    """Simulate until the home hero's turn or the end of nine innings."""
    while s["status"] == "playing":
        if s["outs"] >= 3 or s["halfPA"] >= 100:
            if s["side"] == "away":
                if s["inning"] == 9 and s["home"] > s["away"]:
                    s["status"] = "complete"
                    break
                s["side"] = "home"
            else:
                if s["inning"] == 9:
                    s["status"] = "complete"
                    break
                s["inning"] += 1
                s["side"] = "away"
            s["outs"] = s["halfPA"] = 0
            s["bases"] = [None]*3
        s[s["side"] + "Line"][s["inning"]-1] = s[s["side"] + "Line"][s["inning"]-1] or 0
        if s["side"] == "home" and s["homeIndex"] == home["heroIndex"]:
            break
        team = home if s["side"] == "home" else away
        other = away if s["side"] == "home" else home
        defense = sum(p["contact"] for p in other["players"])/9
        apply_pa(s, team, cpu_result(team["players"][s[s["side"] + "Index"]], defense))
    if s["status"] == "complete":
        s["pending"] = None
        s["winner"] = "home" if s["home"] > s["away"] else "away" if s["away"] > s["home"] else "tie"


def pitch(s):
    if s["pending"]:
        return
    kind = RNG.choice(["FASTBALL", "CURVEBALL", "SLIDER", "CHANGEUP", "SINKER"])
    s["pending"] = {"id": secrets.token_hex(12), "kind": kind,
                    "duration": RNG.randint(880, 1220), "zone": RNG.random() < .83,
                    "curve": {"FASTBALL": 0, "CURVEBALL": 65, "SLIDER": -50,
                              "CHANGEUP": 18, "SINKER": -20}[kind], "issued": time.time()}


def swing(s, home, away, elapsed):
    p = s["pending"]
    player = home["players"][home["heroIndex"]]
    if elapsed is None:
        call = "STRIKE" if p["zone"] else "BALL"
    else:
        error = abs(elapsed/1000 - p["duration"]*.84/1000)
        scale = .8 + min(200, player["contact"])/180
        if error <= .071*scale and p["zone"]:
            if error <= .014*scale:
                call = "HOME RUN" if RNG.random() < min(.72, .26+player["power"]/400) else "DOUBLE"
            elif error <= .037*scale:
                call = "DOUBLE" if RNG.random() < .28 else "SINGLE"
            else:
                call = "SINGLE" if RNG.random() < .58 else "OUT"
        elif error < .12*scale and p["zone"]:
            call = "FOUL"
        else:
            call = "STRIKE"
    s["pending"] = None
    s["lastCall"] = call
    if call == "BALL":
        s["balls"] += 1
        if s["balls"] == 4:
            apply_pa(s, home, "WALK")
    elif call in ("STRIKE", "FOUL"):
        if call == "STRIKE" or s["strikes"] < 2:
            s["strikes"] += 1
        if s["strikes"] == 3:
            apply_pa(s, home, "STRIKEOUT")
            s["lastCall"] = "STRIKEOUT"
    else:
        apply_pa(s, home, call)
    advance(s, home, away)


def autoplay(s, home, away):
    defense = sum(p["contact"] for p in away["players"])/9
    result = cpu_result(home["players"][home["heroIndex"]], defense)
    s["lastCall"] = result
    apply_pa(s, home, result)
    advance(s, home, away)


def public_state(s):
    out = copy.deepcopy(s)
    if out["pending"]:
        out["pending"].pop("issued", None)
    return out
