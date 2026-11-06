"""Six independent test accounts for the AIR league acceptance test."""
import json
from pathlib import Path
import secrets
import tempfile
from server import Service, make_server

root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix='bh-league-qa-') as temporary:
    service=Service(Path(temporary)/'private.sqlite3')
    server=make_server(service,8767)
    names=['Kediri Heroes','Boston Falcons','Seattle Sharks','Los Angeles Knights','Colorado Wolves','Toronto Rockets']
    accounts=[]
    for i,name in enumerate(names):
        account=service.request('POST','/register',{'username':'friend'+str(i),'name':'Amigo '+str(i+1),'password':secrets.token_urlsafe(20),'invite':service.bootstrap()})
        team={'name':name,'accent':0x246bb6,'heroIndex':3,'players':[{'id':'p'+str(j),'name':'Jugador '+str(j+1),'power':78,'contact':83,'speed':70} for j in range(9)]}
        service.request('POST','/team',{'requestId':secrets.token_hex(16),'team':team},account['token'])
        accounts.append(account)
    path=root/'build/qa/league065-config.json'
    path.write_text(json.dumps({'url':'http://127.0.0.1:8767','accounts':accounts}),encoding='utf-8')
    print('Isolated six-account league QA server ready on 8767',flush=True)
    try:server.serve_forever()
    except KeyboardInterrupt:pass
    finally:
        server.server_close();path.unlink(missing_ok=True)
