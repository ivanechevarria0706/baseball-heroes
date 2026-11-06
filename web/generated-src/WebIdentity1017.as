package {
 import flash.display.Sprite;
 import flash.external.ExternalInterface;
 import com.bh.model.GameData;
 public class WebIdentity1017 extends Sprite {
  private var checks:Array=[];
  public function WebIdentity1017(){GameData.init();ExternalInterface.addCallback("identityChecks",run);ExternalInterface.call("BHWeb.ready");}
  private function check(ok:Boolean,label:String):void{if(!ok)throw new Error(label);checks.push(label);}
  private function run():String {try {
   var original:Object=InitialChecks1011.run();check(original.status=="PASS","existing initial progression checks pass");
   GameData.resetSave();check(GameData.teamSelectionOpen()&&!GameData.characterCreationOpen(),"new account chooses its team first");
   GameData.setTeamIdentity("My Club","CHICAGO",0x3a74ad,63);GameData.setOnboardingStep(GameData.ONBOARDING_CHARACTER);
   check(!GameData.teamSelectionOpen()&&GameData.characterCreationOpen(),"team confirmation closes selection and opens creation");
   GameData.setTeamIdentity("My Club","BOSTON",0xcc1100,63);
   check(GameData.teamCity=="CHICAGO"&&GameData.teamAccent==0x3a74ad&&GameData.mainPlayer().accent==0x3a74ad,"a repeated team callback cannot change city or colors");
   var appearance:Object={shape:4,hair:6,eyes:3,nose:2,mouth:1,skinColor:3,hairColor:8,eyeColor:4,etc:0,gender:"F"};
   GameData.setHeroAppearance(appearance);var chosen:String=JSON.stringify(GameData.heroAppearance());
   check(GameData.heroAppearance().shape==4&&GameData.heroAppearance().hair==6&&GameData.heroAppearance().gender=="F","initial character choices are accepted");
   GameData.setOnboardingStep(GameData.ONBOARDING_ARRIVAL);appearance.hair=0;appearance.shape=0;GameData.setHeroAppearance(appearance);
   check(JSON.stringify(GameData.heroAppearance())==chosen,"confirmed appearance cannot be changed");
   var coins:int=GameData.coins,xp:int=GameData.xp;GameData.save();GameData.load();
   check(!GameData.teamSelectionOpen()&&!GameData.characterCreationOpen()&&JSON.stringify(GameData.heroAppearance())==chosen,"confirmation remains locked after reload");
   check(GameData.coins==coins&&GameData.xp==xp,"locking never changes earned resources");
   GameData.completeOnboarding();GameData.restartOnboarding();
   check(GameData.onboardingStep==GameData.ONBOARDING_HOME&&!GameData.teamSelectionOpen()&&!GameData.characterCreationOpen(),"replaying tutorial starts at HOME with creation locked");
   GameData.setHeroAppearance(appearance);GameData.setTeamIdentity("Renamed Club","BOSTON",0xffffff,27);
   check(GameData.teamCity=="CHICAGO"&&GameData.teamAccent==0x3a74ad&&JSON.stringify(GameData.heroAppearance())==chosen,"tutorial replay cannot replace team or character");
   check(GameData.teamName=="RENAMED CLUB"&&GameData.uniformNumber==27,"existing NAME lesson keeps its label and number editing");
   GameData.startNewCareer();
   check(GameData.onboardingStep==GameData.ONBOARDING_HOME&&GameData.teamCity=="CHICAGO"&&JSON.stringify(GameData.heroAppearance())==chosen,"new career preserves confirmed identity and does not reopen creation");
   check(GameData.level==1&&GameData.leagueIndex==0&&GameData.coins==6000,"new career still starts level one Rookie");
   GameData.resetSave();GameData.setTeamIdentity("Draft","SEATTLE",0x3f82b4,32);GameData.setOnboardingStep(GameData.ONBOARDING_CHARACTER);GameData.restartOnboarding();
   check(GameData.characterCreationOpen()&&!GameData.teamSelectionOpen(),"unfinished creator resumes without reopening its chosen team");
   GameData.startNewCareer();check(GameData.characterCreationOpen()&&GameData.teamCity=="SEATTLE","unfinished creation remains available after career restart");
   return JSON.stringify({status:"PASS",checks:checks,total:checks.length,existingProgressionChecks:original.total});
  }catch(e:Error){return JSON.stringify({status:"FAIL",error:e.message,checks:checks});}return "{}";}
 }
}
