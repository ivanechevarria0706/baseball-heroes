'use strict';
(() => {
  const $ = id => document.getElementById(id);
  let user, player, release, initial, snapshot, revision = 0, dirty = false, pending = null;
  let saving = null, saveTimer, startupTimer, stopped = false, registering = false, draftKey;
  let bootId = 0, sessionId = 0, downloadController, gameReady = false;
  let restore = null, readingBackup = false, restoring = false;
  let boot = {phase:'idle', attempts:0, received:0, total:0, movieStarted:false};
  const controls = enabled => ['new-career','import-save','fullscreen'].forEach(id => $(id).disabled = !enabled);
  function bootRecord(code = '') {
    const data = {...boot, version:release?.version, build:release?.build, elapsedMs:Math.round(performance.now() - (boot.startedAt || performance.now())), code};
    delete data.startedAt;
    try { sessionStorage.setItem('bh.startup.last', JSON.stringify(data)); if(code)sessionStorage.setItem('bh.startup.lastFailure',JSON.stringify(data)); } catch (_) {}
    return data;
  }
  window.BHStartup = {diagnostics:() => bootRecord(boot.code || '')};
  function progress(received, total) {
    boot.received=received; boot.total=total;
    const meter=$('load-progress');
    if (total) { const percent=Math.min(100, Math.floor(received*100/total)); meter.setAttribute('aria-valuenow', percent); $('load-progress-bar').style.width=percent+'%'; }
    else { meter.removeAttribute('aria-valuenow'); $('load-progress-bar').style.width='0%'; }
    $('load-details').textContent=(received/1048576).toFixed(1)+' MB'+(total?' / '+(total/1048576).toFixed(1)+' MB':' descargados');
  }
  function bootFailed(code, phase, id) {
    if(id!==bootId || gameReady || stopped)return;
    boot.code=code; boot.phase='failed'; boot.failurePhase=phase;
    const sessionEnded=code==='HTTP_401'||code==='HTTP_403';
    const message=sessionEnded?'Tu sesión terminó. Recarga la página para volver a iniciar sesión.':phase==='download'?'No se pudo completar la descarga. Tu progreso sigue guardado; puedes volver a intentar la carga.':'No se pudo iniciar el juego. Tu guardado se conserva; recarga la página para volver a intentarlo.';
    $('loading').hidden=true;if(player)player.hidden=true;problem(message);
    $('retry-load').hidden=phase!=='download'||sessionEnded;
    console.warn('[BH startup]',bootRecord(code));
  }
  async function loadGame() {
    const id=++bootId;downloadController?.abort();clearTimeout(startupTimer);
    if(player){player.ruffle().suspend();player.remove();player=null;}
    downloadController=new AbortController();stopped=false;gameReady=false;controls(false);
    boot={phase:'download',attempts:1,received:0,total:0,movieStarted:false,startedAt:performance.now()};
    $('problem').hidden=true;$('retry-load').hidden=true;$('loading').hidden=false;
    $('loading').dataset.phase='download';$('load-status').textContent='Descargando el juego…';progress(0,0);status('Loading game…');
    try {
      const bytes=await BHGameCache.run(release,{signal:downloadController.signal,
        source:value=>{if(id===bootId)boot.source=value;},
        progress:(received,total)=>{if(id===bootId&&!stopped)progress(received,total);},
        retry:(number,code)=>{if(id!==bootId||stopped)return;boot.attempts=number;boot.lastDownloadError=code;progress(0,0);$('load-status').textContent='Reintentando la descarga… ('+number+'/3)';}});
      if(id!==bootId||stopped)return;
      boot.phase='starting';$('loading').dataset.phase='starting';$('load-status').textContent='Preparando tu equipo…';$('load-details').textContent='Descarga completa. Abriendo tu partida guardada.';
      player=window.RufflePlayer.newest().createPlayer();$('game-frame').append(player);
      player.ruffle().traceObserver=message=>{if(message.startsWith('SAVE ERROR:')||message.startsWith('LOAD ERROR:'))problem('Could not restore your save. Your cloud copy is preserved.');};
      const waiting=()=>bootFailed('START_TIMEOUT','engine',id);
      startupTimer=setTimeout(waiting,90000);
      player.addEventListener('loadedmetadata',()=>{if(id!==bootId||stopped||gameReady)return;clearTimeout(startupTimer);startupTimer=setTimeout(waiting,60000);},{once:true});
      boot.movieStarted=true;
      await player.ruffle().load({data:bytes,swfFileName:new URL(release.game,location.href).href,base:new URL('.',new URL(release.game,location.href)).href,allowScriptAccess:true,autoplay:'on',unmuteOverlay:'visible',
        contextMenu:'off',logLevel:'warn',backgroundColor:'#143148',letterbox:'on',preferredRenderer:'webgl'});
    }catch(error){if(typeof error.code!=='string'){boot.errorType=String(error.name||'Error').slice(0,40);boot.detail=String(error.message||'').replace(/https?:\/\/\S+/g,'[resource]').replace(/[\r\n]/g,' ').slice(0,180);}bootFailed(typeof error.code==='string'?error.code:boot.phase==='download'?'DOWNLOAD_ERROR':'ENGINE_ERROR',boot.phase==='download'?'download':'engine',id);}
  }
  const status = text => { $('save-status').textContent = text; };
  function applyReleaseReset(latest) {
    if (!latest.resetEpoch) return;
    try {
      if (localStorage.getItem('bh.web.resetEpoch') === latest.resetEpoch) return;
      // Only this game's unsent drafts belong to the pre-release reset.
      // Account IDs are new after reset, so old tabs cannot restore them.
      for (const key of Object.keys(localStorage)) {
        if (key.startsWith('bh.web.draft.v1.')) localStorage.removeItem(key);
      }
      localStorage.setItem('bh.web.resetEpoch', latest.resetEpoch);
    } catch (_) { /* Storage can be disabled; the cloud remains authoritative. */ }
  }
  async function api(path, body, method = body === undefined ? 'GET' : 'POST', accountId = user?.id) {
    let response;
    const headers = body === undefined ? {} : {'Content-Type':'application/json'};
    if(accountId && path.startsWith('/web/') && !['/web/login','/web/register'].includes(path))headers['X-BH-Account']=accountId;
    try{response = await fetch(path, {method, credentials:'same-origin', cache:'no-store',
      headers,
      body: body === undefined ? undefined : JSON.stringify(body), signal:AbortSignal.timeout(30000)});}
    catch(_){throw new Error('The connection timed out or was interrupted. Try again when you are connected.');}
    const result = await response.json();
    if (!response.ok) { const error = new Error(result.error || 'Could not connect.'); error.status=response.status; throw error; }
    return result;
  }
  function storeDraft() {
    try { localStorage.setItem(draftKey,JSON.stringify({revision,data:snapshot,pending})); }
    catch (_) { status('Changes are pending. Keep this page open until they are saved.'); }
  }
  function problem(message) {
    clearTimeout(startupTimer);downloadController?.abort();controls(false);$('retry-load').hidden=true;stopped=true; player?.ruffle().suspend(); $('problem-text').textContent=message;
    $('problem').hidden=false; status('Game paused · Check the notice');
  }
  async function flush() {
    clearTimeout(saveTimer);
    if (saving) return saving;
    if (stopped || !dirty) return !dirty;
    saving=(async()=>{
      while(dirty && !stopped) {
        if (!pending) pending={revision,data:JSON.parse(snapshot),requestId:crypto.randomUUID()};
        storeDraft(); status('Saving to cloud…');
        try {
          const result=await api('/web/save',pending);
          revision=result.revision;
          dirty=snapshot!==JSON.stringify(pending.data); pending=null;
          if(dirty)storeDraft();else {try{localStorage.removeItem(draftKey);}catch(_){} }
          $('retry-save').hidden=true; status('Saved to cloud ✓');
        } catch(error) {
          if(error.status===409)problem(error.message+' Your local copy is preserved and can be downloaded.');
          else if(error.status===401)problem('Your session expired. Download the local copy before signing in again.');
          else { status('Unsaved · Your local copy is still on this computer'); $('retry-save').hidden=false; }
          return false;
        }
      }
      return !dirty;
    })();
    try{return await saving;}finally{saving=null;}
  }
  async function start(session) {
    const attempt=++sessionId;
    const cloud=await api('/web/save',undefined,'GET',session.user.id),latest=await api('/version.json');
    if(attempt!==sessionId)return;
    user=session.user;draftKey='bh.web.draft.v1.'+user.id;release=latest;
    applyReleaseReset(release);
    document.querySelector('.edition .tag').textContent='WEB '+release.version;
    revision=cloud.revision;initial=cloud.data;snapshot=JSON.stringify(initial);pending=null;dirty=false;stopped=false;
    let draft;
    try{draft=JSON.parse(localStorage.getItem(draftKey));}catch(_){}
    if(draft && draft.data!==JSON.stringify(cloud.data)) {
      snapshot=draft.data;dirty=true;
      if(draft.revision!==revision) {
        $('welcome').hidden=true;$('club').hidden=false;
        problem('This computer has pending changes and the cloud has a newer copy. Download the local copy before reloading to preserve it.');return;
      }
      initial=JSON.parse(snapshot);pending=draft.pending || null;
    } else {try{localStorage.removeItem(draftKey);}catch(_){} }
    $('greeting').textContent='Hello, '+user.name;$('welcome').hidden=true;$('club').hidden=false;
    await loadGame();
  }

  window.BHWeb={
    initialSave:()=>{
      const data=structuredClone(initial);
      // Ruffle's AS3 JSON parser truncates large integer literals. Migrate
      // existing numeric timers before that parser sees the saved snapshot.
      if(data&&data.gateIncomeLastAt!=null)data.gateIncomeLastAt=String(data.gateIncomeLastAt);
      if(data&&data.specialOwned)for(const card of Object.values(data.specialOwned)) {
        if(card&&typeof card==='object'&&card.rechargeAt!=null)card.rechargeAt=String(card.rechargeAt);
      }
      return JSON.stringify(data);
    },origin:()=>location.origin,
    session:()=>JSON.stringify({url:location.origin,user}),requestId:()=>crypto.randomUUID(),
    friendTarget:()=>{const id=new URLSearchParams(location.search).get('friend')||'';return /^[a-f0-9]{32}$/.test(id)?id:'';},
    clearFriendTarget:()=>{const url=new URL(location.href);url.searchParams.delete('friend');history.replaceState(null,'',url.pathname+url.search+url.hash);},
    save:text=>{
      if(stopped)return;
      // AS3 writes large timestamps in scientific notation. Compare the same
      // JSON representation as pending.data or an unchanged save loops forever.
      try{const next=JSON.stringify(JSON.parse(text));if(next===snapshot&&!dirty)return;snapshot=next;}
      catch(_){problem('The game could not prepare the save. Your latest cloud progress is still available.');return;}
      dirty=true;storeDraft();status('Changes pending…');clearTimeout(saveTimer);saveTimer=setTimeout(flush,650);
    },
    ready:()=>{clearTimeout(startupTimer);if(stopped||gameReady)return;gameReady=true;boot.phase='ready';boot.code='';bootRecord();controls(true);if(!dirty)status('Saved to cloud ✓');$('loading').hidden=true;window.dispatchEvent(new Event('bh-ready'));},
    gameError:()=>{boot.code='MOVIE_ERROR';boot.failurePhase=boot.phase;bootRecord('MOVIE_ERROR');problem('The game encountered a compatibility error. Your latest cloud save is still available.');},
    expired:()=>problem('Your session ended. Reload the page to sign in again.'),
    copyInvite:code=>{navigator.clipboard?.writeText(code).catch(()=>{});},
    request:(id,method,path,text)=>{
      if(stopped)return;
      if(!/^\/[a-z0-9_/-]+$/.test(path)||!['GET','POST'].includes(method))return;
      // Leave the current game intact until its pending save is acknowledged.
      const run=async()=>{
        if((path==='/logout'||path==='/scores') && !(await flush()))throw new Error('Save your changes before continuing.');
        return api('/web/api'+path,method==='POST'?JSON.parse(text):undefined,method);
      };
      run().then(result=>{if(path==='/logout'){location.reload();return;}player.ruffle().callExternalInterface('bhResponse',id,true,JSON.stringify(result),200);})
        .catch(error=>{player.ruffle().callExternalInterface('bhResponse',id,false,JSON.stringify({error:error.message}),error.status||0);});
    }
  };
  $('toggle-register').onclick=()=>{
    registering=!registering;$('register-fields').hidden=!registering;
    $('display-name').required=registering;$('auth-status').textContent='';
    $('password').autocomplete=registering?'new-password':'current-password';
    $('form-title').textContent=registering?'Create account':'Sign in';
    $('submit').textContent=registering?'CREATE ACCOUNT & PLAY →':'PLAY BALL →';
    $('toggle-register').textContent=registering?'Already have an account? Sign in':'Create account';
  };
  $('auth').onsubmit=async event=>{
    event.preventDefault();sessionId++;$('submit').disabled=true;$('auth-status').textContent='Connecting to your club…';
    const body={username:$('username').value.trim(),password:$('password').value};
    if(registering){body.name=$('display-name').value.trim();}
    try{
      let session;
      try{session=await api(registering?'/web/register':'/web/login',body);}
      catch(error){
        if(!registering||error.status)throw error;
        // A lost registration response may already have created the account.
        // Login proves ownership without submitting a second registration.
        $('auth-status').textContent='Checking whether your account was created…';
        session=await api('/web/login',{username:body.username,password:body.password});
      }
      $('password').value='';await start(session);
    }
    catch(error){$('auth-status').textContent=error.message;}
    finally{$('submit').disabled=false;}
  };
  $('retry-save').onclick=flush;
  $('retry-load').onclick=()=>{if(boot.phase==='failed'&&boot.failurePhase==='download')loadGame();};
  $('new-career').onclick=async()=>{
    if(stopped||!player)return;
    if(!confirm('Start at level 1 in ROOKIE with no results and basic equipment. Your hero\'s name and appearance will be preserved. A backup of your current career will be downloaded first. Friend challenges and leagues are preserved. Start a new career?'))return;
    $('new-career').disabled=true;
    player.ruffle().callExternalInterface('bhFlush');player.ruffle().suspend();
    try{
      if(!(await flush())){if(!stopped)player.ruffle().resume();return;}
      $('download-save').click();
      if(player.ruffle().callExternalInterface('bhNewCareer')!==true)throw new Error('Could not start the career. Keep your backup and try again.');
      if(await flush())location.reload();
      else if(!stopped)problem('Your new career is waiting for a connection. The local copy is preserved; reload when you are online again.');
    }catch(error){if(!stopped)player.ruffle().resume();alert(error.message);}
    finally{$('new-career').disabled=false;}
  };
  function downloadSnapshot(text) {
    const url=URL.createObjectURL(new Blob([text||'null'],{type:'application/json'}));
    const a=document.createElement('a');a.href=url;a.download='Baseball-Heroes-backup-'+new Date().toISOString().slice(0,10)+'.json';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
  }
  function closeRestore() {
    if(restoring)return;
    restore=null;$('import-dialog').close();
    if(!stopped)player?.ruffle().resume();
    $('import-save').focus();
  }
  $('import-save').onclick=()=>{if(gameReady&&!stopped&&!restore&&!readingBackup)$('save-file').click();};
  $('save-file').onchange=async()=>{
    const file=$('save-file').files[0];if(!file||readingBackup||restore||stopped||!gameReady)return;
    readingBackup=true;
    try{
      if(file.size>512*1024)throw new Error('La copia supera el tamaño permitido de 512 KB.');
      const accountId=user.id,parsed=BHBackup.parse(await file.text());
      if(stopped||user.id!==accountId)return;
      player?.ruffle().callExternalInterface('bhFlush');player?.ruffle().suspend();
      if(!(await flush())){if(!stopped)player?.ruffle().resume();return;}
      restore={...parsed,accountId,baseRevision:revision,baseSnapshot:snapshot,backedUp:false};
      $('import-file').textContent=file.name;$('import-account').textContent=user.name;
      $('import-version').textContent=parsed.sourceVersion===24?'Formato v24 · compatible':`Formato v${parsed.sourceVersion} → v24 · se conserva tu progreso`;
      const current=BHBackup.summary(JSON.parse(snapshot)),backup=BHBackup.summary(parsed.data);
      $('import-rows').replaceChildren();
      backup.forEach(([label,value],i)=>{const row=document.createElement('tr');[label,current[i][1],value].forEach((text,index)=>{const cell=document.createElement(index===0?'th':'td');cell.textContent=text;if(index===0)cell.scope='row';row.append(cell);});$('import-rows').append(row);});
      $('import-error').textContent='';$('import-backup-note').textContent='Descarga primero una copia de tu carrera actual para poder volver a ella.';
      $('import-confirm').disabled=true;$('import-cancel').disabled=false;$('import-backup-current').disabled=false;
      $('import-dialog').showModal();
    }catch(error){restore=null;if(!stopped)player?.ruffle().resume();alert(error.message);}
    finally{readingBackup=false;$('save-file').value='';}
  };
  $('import-cancel').onclick=closeRestore;
  $('import-dialog').addEventListener('cancel',event=>{event.preventDefault();closeRestore();});
  $('import-backup-current').onclick=()=>{
    if(!restore||restoring)return;
    downloadSnapshot(restore.baseSnapshot);restore.backedUp=true;$('import-confirm').disabled=false;
    $('import-backup-note').textContent='Se solicitó la descarga de tu copia actual. Guárdala antes de continuar.';
  };
  $('import-confirm').onclick=async()=>{
    if(!restore||!restore.backedUp||restoring||stopped)return;
    restoring=true;$('import-confirm').disabled=true;$('import-cancel').disabled=true;$('import-backup-current').disabled=true;
    let replaced=false;
    try{
      const cloud=await api('/web/save',undefined,'GET',restore.accountId);
      if(cloud.revision!==restore.baseRevision)throw Object.assign(new Error('La nube cambió mientras revisabas la copia. Descarga tu copia local y recarga la nube antes de continuar.'),{status:409});
      snapshot=JSON.stringify(restore.data);pending=null;dirty=true;replaced=true;storeDraft();
      if(await flush())location.reload();
      else if(!stopped)problem('La importación está pendiente de conexión. Tu copia local se conserva; recarga cuando vuelvas a estar conectado.');
      $('import-dialog').close();restore=null;
    }catch(error){
      if(error.status===409||error.status===401||replaced){problem(error.message);$('import-dialog').close();restore=null;}
      else{$('import-error').textContent='No se pudo comprobar la nube. Tu carrera sigue intacta. Vuelve a intentarlo cuando tengas conexión.';}
    }finally{restoring=false;$('import-cancel').disabled=false;$('import-backup-current').disabled=false;$('import-confirm').disabled=!restore?.backedUp;}
  };
  $('fullscreen').onclick=()=>player?.ruffle().requestFullscreen();
  $('logout').onclick=async()=>{
    if(!gameReady&&!dirty){try{await api('/web/api/logout',{requestId:crypto.randomUUID()});downloadController?.abort();location.reload();}catch(error){status(error.message);}return;}
    if(stopped)return;
    player?.ruffle().callExternalInterface('bhFlush');player?.ruffle().suspend();
    if(!(await flush())){if(!stopped)player?.ruffle().resume();return;}
    try{await api('/web/api/logout',{requestId:crypto.randomUUID()});location.reload();}
    catch(error){status(error.message);player?.ruffle().resume();}
  };
  $('download-save').onclick=()=>downloadSnapshot(snapshot);
  $('reload-cloud').onclick=()=>{
    if(dirty && !confirm('The cloud copy will be opened. Have you downloaded the local changes you want to keep?'))return;
    try{localStorage.removeItem(draftKey);}catch(_){} dirty=false;location.reload();
  };
  $('update-button').onclick=async()=>{
    player?.ruffle().callExternalInterface('bhFlush');player?.ruffle().suspend();
    if(await flush())location.reload();else if(!stopped)player?.ruffle().resume();
  };
  window.addEventListener('beforeunload',event=>{if(dirty){event.preventDefault();event.returnValue='';}});
  window.addEventListener('online',()=>{if(!stopped)flush();});
  document.addEventListener('visibilitychange',()=>{if(document.hidden&&!stopped)flush();});
  async function checkUpdate(){if(!release)return;try{const latest=await api('/version.json');$('update').hidden=latest.build===release.build;}catch(_){}}
  setInterval(checkUpdate,60000);
  window.addEventListener('focus',checkUpdate);
  (async()=>{
    try {
      const latest=await api('/version.json');applyReleaseReset(latest);
      document.querySelector('.edition .tag').textContent='WEB '+latest.version;
      await start(await api('/web/session'));
    } catch(error) {
      if(error.status!==401)$('auth-status').textContent='Could not restore your session. Try signing in again.';
    }
  })();
})();
