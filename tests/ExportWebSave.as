package {
    import flash.display.Sprite;
    import flash.net.SharedObject;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.utils.setTimeout;
    public class ExportWebSave extends Sprite {
        public function ExportWebSave() {
            setTimeout(exportSave,150);
        }
        private function exportSave():void {
            try {
                var data:Object=SharedObject.getLocal("baseballHeroesRemakeSave").data;
                if(int(data.version)!=21)throw new Error("No hay una partida v21 para exportar en este perfil.");
                var file:File=File.applicationDirectory.resolvePath("Partida_para_web.json");
                var stream:FileStream=new FileStream();stream.open(file,FileMode.WRITE);stream.writeUTFBytes(JSON.stringify(data));stream.close();
                NativeApplication.nativeApplication.exit(0);
            } catch(e:Error) {
                var log:FileStream=new FileStream();log.open(File.applicationDirectory.resolvePath("export-status.txt"),FileMode.WRITE);
                log.writeUTFBytes(e.message+"\nVersion: "+(data?data.version:"missing")+"\nStorage: "+File.applicationStorageDirectory.nativePath);log.close();
                NativeApplication.nativeApplication.exit(1);
            }
        }
    }
}
