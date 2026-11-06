'use strict';
(() => {
  const fail = message => { throw new Error(message); };
  const object = value => value !== null && typeof value === 'object' && !Array.isArray(value);
  const bytes = value => new TextEncoder().encode(value).length;
  function walk(value, depth = 0) {
    if (depth > 40) fail('La copia contiene demasiados niveles de datos.');
    if (typeof value === 'number' && !Number.isFinite(value)) fail('La copia contiene números no válidos.');
    if (object(value)) for (const key of Object.keys(value)) {
      if (['__proto__','constructor','prototype'].includes(key)) fail('La copia contiene un campo no permitido.');
      walk(value[key], depth + 1);
    }
    else if (Array.isArray(value)) for (const item of value) walk(item, depth + 1);
  }
  window.BHBackup = {
    parse(text) {
      if (typeof text !== 'string' || bytes(text) > 512 * 1024) fail('La copia es demasiado grande.');
      let data;
      try { data = JSON.parse(text.replace(/^\uFEFF/, '')); } catch (_) { fail('El archivo no es una copia JSON válida.'); }
      if (!object(data) || ![21,22,23,24].includes(data.version)) fail('Esta versión de copia no es compatible. Se admiten v21 a v24.');
      if (!Array.isArray(data.roster) || !data.roster.length || data.roster.length > 1000 || data.roster.some(p => !object(p) || typeof p.name !== 'string' || !p.name.trim() || p.name.length > 120)) fail('La copia no contiene una plantilla válida.');
      walk(data);
      const sourceVersion = data.version;
      // Versions 21-24 share the fields read by GameData. Its existing loader
      // fills missing fields; only the envelope must match the current schema.
      if (sourceVersion < 24) {
        if (data.starterTutorial === undefined) data.starterTutorial = {version:2,lesson:1,enabled:false,stage:9,cardId:'',fixtureKey:'',claimed:false,skipped:false,hints:{}};
        if (data.seasonGoalType === undefined) data.seasonGoalType = 'HR';
        if (data.seasonGoalHits === undefined) data.seasonGoalHits = 70;
        if (data.seasonHeroHits === undefined) data.seasonHeroHits = 0;
        if (data.seasonHeroRbi === undefined) data.seasonHeroRbi = 0;
        data.version = 24;
      }
      if (bytes(JSON.stringify(data)) > 512 * 1024) fail('La copia actualizada supera el tamaño permitido.');
      return {data, sourceVersion};
    },
    summary(data) {
      const value = key => Number.isFinite(data?.[key]) ? data[key].toLocaleString('en-US') : '—';
      return [
        ['Hero', data?.roster?.[0]?.name || '—'], ['Team', typeof data?.teamName === 'string' ? data.teamName : '—'],
        ['Level',value('level')], ['League',['ROOKIE','SINGLE-A','DOUBLE-A','TRIPLE-A','MAJOR'][data?.leagueIndex] || '—'],
        ['Season',value('seasonNumber')], ['Coins',value('coins')], ['XP',value('xp')],
        ['Special cards',object(data?.specialOwned) ? String(Object.keys(data.specialOwned).length) : '—']
      ];
    }
  };
})();
