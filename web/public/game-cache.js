'use strict';
(() => {
  const digest = async bytes => Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',bytes)),n=>n.toString(16).padStart(2,'0')).join('');
  window.BHGameCache = {
    async run(release, options = {}) {
      const expected=release.gameSha256;
      const url=new URL(release.game,location.href);
      const key=new URL(url);key.searchParams.set('bh-sha256',expected);
      let cache;
      if(/^[a-f0-9]{64}$/.test(expected||'') && globalThis.caches && crypto.subtle) {
        try{cache=await caches.open('bh-game-v1');}catch(_){}
      }
      if(cache) {
        let bytes;
        try{const response=await cache.match(key.href);if(response)bytes=new Uint8Array(await response.arrayBuffer());}catch(_){}
        if(bytes && await digest(bytes)===expected) {
          // A local copy never substitutes for authentication at the server.
          let response;
          try{response=await fetch(url,{method:'HEAD',credentials:'same-origin',cache:'no-store',signal:AbortSignal.timeout(30000)});}catch(_){}
          if(response?.status===401||response?.status===403)throw Object.assign(new Error('Session ended'),{code:'HTTP_'+response.status});
          if(response?.ok) {options.source?.('cache');options.progress?.(bytes.length,bytes.length);return bytes;}
          // Temporary HEAD failures use the existing bounded download retries.
        }
      }
      options.source?.('network');
      const bytes=await BHGameDownload.run(release.game,options);
      if(cache) {
        if(await digest(bytes)!==expected)throw Object.assign(new Error('Game checksum differs'),{code:'GAME_CHECKSUM'});
        try {
          await cache.put(key.href,new Response(bytes,{headers:{'Content-Type':'application/x-shockwave-flash'}}));
          for(const old of await cache.keys())if(new URL(old.url).pathname===url.pathname&&old.url!==key.href)await cache.delete(old);
        }catch(_){/* Storage limits must not prevent a verified game from starting. */}
      }
      return bytes;
    }
  };
})();
