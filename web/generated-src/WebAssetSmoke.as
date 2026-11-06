package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    import flash.display.Sprite;
    import com.bh.visual.AssetImage;
    import com.bh.visual.VisualAssetRegistry;
    public class WebAssetSmoke extends WebSeasonTransition {
        private var gallery:Sprite;
        private var images:Array=[];
        public function WebAssetSmoke() {
            super();
            ExternalInterface.addCallback("bhAssetLeague",function(league:int):String {
                GameData.leagueIndex=Math.max(0,Math.min(4,league));
                GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;
                GameData.seasonGoalSet=true;GameData.seasonComplete=false;
                GameData.specialMatch=null;GameData.energy=GameData.maxEnergy;GameData.save();
                return JSON.stringify({league:GameData.leagueIndex});
            });
            ExternalInterface.addCallback("bhAssetGallery",function(group:String=""):Boolean {
                for each(var old:AssetImage in images)old.dispose();images=[];
                if(gallery&&gallery.parent)gallery.parent.removeChild(gallery);gallery=null;
                if(!group)return true;
                var names:Array;
                if(group=="transports")names=["rookie_bus","single_a_bus","double_a_bus","triple_a_plane","major_plane"];
                else if(group=="league_badges")names=["rookie","single_a","double_a","triple_a","major"];
                else if(group=="mode_icons")names=["rookie","single_a","double_a","triple_a","major","opening","rival","postseason","allstar","special","world_match","home_run_derby"];
                else if(group=="team_logos")names=["colorado","baltimore","los_angeles_a","new_york","seattle","oakland","pittsburgh","arizona","cincinnati","cleveland","detroit","newyork_alt","saint_louis","los_angeles_b","minnesota","tampa_bay","boston","kansas_city","texas","milwaukee","miami","san_francisco","san_diego","la_field","washington","chicago","atlanta","toronto","houston","philadelphia"];
                else if(group=="card_packs")names=["single_a","double_a","triple_a","major","special_match","national_league","american_league","heroes"];
                else return false;
                gallery=new Sprite();gallery.graphics.beginFill(0xc5d0da);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();addChild(gallery);
                for(var i:int=0;i<names.length;i++){
                    var a:AssetImage=new AssetImage("assets/reference/"+group+"/"+names[i]+".png",174,102);
                    a.name="gallery:"+group+"/"+names[i];
                    a.x=12+(i%5)*189;a.y=12+int(i/5)*116;gallery.addChild(a);images.push(a);
                }
                return true;
            });
        }
    }
}
