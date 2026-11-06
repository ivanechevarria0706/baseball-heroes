'use strict';
(() => {
  const MAX_BYTES = 64 * 1024 * 1024;
  const STALL_MS = 45000;
  const failure = (code, status = 0) => Object.assign(new Error(code), {code, status});
  const cancelled = () => failure('CANCELLED');
  function delay(ms, signal) {
    return new Promise((resolve, reject) => {
      if (signal.aborted) { reject(cancelled()); return; }
      const cancel = () => { clearTimeout(timer); reject(cancelled()); };
      const timer = setTimeout(() => { signal.removeEventListener('abort', cancel); resolve(); }, ms);
      signal.addEventListener('abort', cancel, {once:true});
    });
  }
  async function attempt(url, signal, progress) {
    const controller = new AbortController();
    let timer, stalled = false, reader;
    const cancel = () => controller.abort();
    const activity = () => { clearTimeout(timer); timer = setTimeout(() => { stalled = true; controller.abort(); }, STALL_MS); };
    signal.addEventListener('abort', cancel, {once:true});
    try {
      if (signal.aborted) throw cancelled();
      activity();
      const response = await fetch(url, {credentials:'same-origin', cache:'no-cache', signal:controller.signal});
      if (!response.ok) throw failure('HTTP_' + response.status, response.status);
      const encoded = response.headers.get('Content-Encoding');
      const length = encoded && encoded !== 'identity' ? 0 : Number(response.headers.get('Content-Length')) || 0;
      if (length > MAX_BYTES) throw failure('TOO_LARGE');
      let chunks = [], received = 0;
      if (response.body) {
        reader = response.body.getReader();
        for (;;) {
          const part = await reader.read();
          if (part.done) break;
          received += part.value.byteLength;
          if (received > MAX_BYTES) throw failure('TOO_LARGE');
          chunks.push(part.value); activity(); progress(received, length);
        }
      } else {
        const data = new Uint8Array(await response.arrayBuffer());
        received = data.byteLength;
        if (received > MAX_BYTES) throw failure('TOO_LARGE');
        chunks.push(data); progress(received, length);
      }
      if (signal.aborted) throw cancelled();
      if (length && received !== length) throw failure('INCOMPLETE');
      const bytes = new Uint8Array(received);
      let offset = 0;
      for (const chunk of chunks) { bytes.set(chunk, offset); offset += chunk.byteLength; }
      chunks = [];
      if (bytes.length < 8 || !['FWS','CWS','ZWS'].includes(String.fromCharCode(...bytes.subarray(0, 3)))) throw failure('INVALID_FILE');
      progress(received, received);
      return bytes;
    } catch (error) {
      if (signal.aborted) throw cancelled();
      if (stalled) throw failure('STALLED');
      if (error.code) throw error;
      throw failure('NETWORK');
    } finally {
      clearTimeout(timer); signal.removeEventListener('abort', cancel);
      if (reader) { try { await reader.cancel(); } catch (_) {} }
      controller.abort();
    }
  }
  window.BHGameDownload = {
    async run(path, {signal, progress = () => {}, retry = () => {}}) {
      const url = new URL(path, location.href);
      if (url.origin !== location.origin || !url.pathname.startsWith('/game/') || !url.pathname.endsWith('.swf')) throw failure('INVALID_URL');
      for (let number = 1; number <= 3; number++) {
        try { return await attempt(url.href, signal, progress); }
        catch (error) {
          const transient = ['NETWORK','STALLED','INCOMPLETE'].includes(error.code) || error.status === 408 || error.status === 429 || error.status >= 500;
          if (!transient || number === 3 || signal.aborted) throw error;
          retry(number + 1, error.code);
          await delay(600 * number, signal);
        }
      }
      throw failure('NETWORK');
    }
  };
})();
