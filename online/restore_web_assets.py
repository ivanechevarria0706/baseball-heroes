"""Restore pinned, unchanged game resources from the existing persistent volume."""
import hashlib,json,os
from pathlib import Path,PurePosixPath

def restore(public, data, manifest_path):
    manifest=json.loads(Path(manifest_path).read_text(encoding='utf-8'))
    files=manifest['files']
    identity=hashlib.sha256(json.dumps(files,sort_keys=True,separators=(',',':')).encode()).hexdigest()[:16]
    if manifest['id']!='common-'+identity:raise RuntimeError('Invalid shared resource manifest.')
    public=Path(public).resolve();bundle=Path(data).resolve()/'web-static'/manifest['id']
    for relative,expected in files.items():
        path=PurePosixPath(relative)
        if path.is_absolute() or '..' in path.parts or not (relative.startswith('game/assets/') or relative.startswith('ruffle/')):
            raise RuntimeError('Invalid shared resource path.')
        source=bundle.joinpath(*path.parts);target=public.joinpath(*path.parts)
        if not source.resolve().is_relative_to(bundle.resolve()) or not target.resolve().is_relative_to(public):
            raise RuntimeError('Shared resource path escaped its directory.')
        content=source.read_bytes()
        if hashlib.sha256(content).hexdigest()!=expected:raise RuntimeError('Shared resource checksum mismatch: '+relative)
        if target.exists():
            if hashlib.sha256(target.read_bytes()).hexdigest()!=expected:raise RuntimeError('Packaged resource mismatch: '+relative)
            continue
        target.parent.mkdir(parents=True,exist_ok=True)
        temporary=target.with_name(target.name+'.partial');temporary.write_bytes(content);temporary.replace(target)
    return len(files)

if __name__=='__main__':
    here=Path(__file__).resolve().parent
    count=restore(here/'web',os.environ.get('BH_DATA_DIR','/data'),here/'shared-web-assets.json')
    print('Pinned game resources verified: '+str(count),flush=True)
    from production import main
    main()
