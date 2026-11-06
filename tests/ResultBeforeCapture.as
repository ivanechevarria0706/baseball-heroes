package {
    import flash.display.*;import flash.filesystem.*;import flash.desktop.NativeApplication;import flash.utils.setTimeout;
    import com.bh.model.GameData;import com.bh.ui.GameResultPanel;import com.bh.visual.MatchStadium;
    /** Compile with research/v056-before-src first to reproduce the archived 0.5.5 panel. */
    public class ResultBeforeCapture extends Sprite {
        public function ResultBeforeCapture(){stage.scaleMode='noScale';stage.align='TL';GameData.init();addChild(new MatchStadium(960,720));
            var summary:Object={win:true,game:12,homeScore:7,awayScore:4,hits:4,homeRuns:1,rbi:7,wins:8,losses:4,rank:2,rewardCoins:3280,rewardXp:212,seasonComplete:false,levelUp:null,homeLine:[0,1,0,0,1,0,0,2,3],awayLine:[1,0,0,1,0,0,2,0,0]};
            addChild(new GameResultPanel(960,720,summary,function():void{}));var view:Sprite=this;setTimeout(function():void {var b:BitmapData=new BitmapData(960,720,false,0x123456);b.draw(view);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/v056-before.png');var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();NativeApplication.nativeApplication.exit();},1200);
        }
    }
}
