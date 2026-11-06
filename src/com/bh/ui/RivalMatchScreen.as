package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.geom.Point;import flash.utils.getTimer;import flash.ui.Keyboard;
    import com.bh.online.OnlineClient;
    import com.bh.game.*;
    import com.bh.visual.MatchStadium;
    import com.bh.audio.GameplayAudio;

    /** Exhibition view. Only server responses can change the match scoreboard. */
    public class RivalMatchScreen extends Sprite {
        private var api:OnlineClient,onBack:Function,match:Object;
        private var stadium:MatchStadium,batter:ClassicBatter,pitcher:Pitcher,ball:Ball;
        private var hud:Sprite=new Sprite(),controls:Sprite=new Sprite();
        private var headline:TextField,score:TextField,lines:TextField,help:TextField,log:TextField;
        private var phase:String="READY",pitchStart:int,windupEnd:int,resultEnd:int,origin:Point;
        private var callout:GameplayCallout;
        private var previousFrameRate:Number=30;
        private var pendingPath:String,pendingBody:Object;
        private var alive:Boolean=true,canPlay:Boolean;

        public function RivalMatchScreen(client:OnlineClient,data:Object,back:Function) {
            api=client;match=data;onBack=back;name="rival-match";
            canPlay=match.homeId==api.user.id;
            stadium=new MatchStadium(960,720);addChild(stadium);
            var hero:Object=match.homeTeam.players[match.homeTeam.heroIndex];
            batter=new ClassicBatter(262,640,uint(match.homeTeam.accent),8,String(hero.name));batter.scaleX=batter.scaleY=1.5;addChild(batter);
            pitcher=new Pitcher(480,360,uint(match.awayTeam.accent),"Rival");pitcher.scaleX=pitcher.scaleY=.72;addChild(pitcher);
            ball=new Ball(480,330);ball.hideBall();addChild(ball);callout=new GameplayCallout();callout.x=480;callout.y=260;addChild(callout);addChild(hud);addChild(controls);
            hud.mouseEnabled=false;hud.graphics.beginFill(0x102c43,.96);hud.graphics.drawRect(0,0,960,133);hud.graphics.endFill();
            headline=ClassicInventorySkin.text(hud,match.league?"LEAGUE · "+match.league.name+" · ROUND "+match.league.round:"RIVAL · PRIVATE FRIENDLY",18,9,770,25,17);
            score=ClassicInventorySkin.text(hud,"",18,37,810,30,21,0xffd95a);
            lines=ClassicInventorySkin.text(hud,"",18,77,835,50,13);
            hud.graphics.beginFill(0x102c43,.95);hud.graphics.drawRoundRect(350,520,590,103,12);hud.graphics.endFill();
            help=ClassicInventorySkin.text(hud,"",367,533,552,77,16);
            log=ClassicInventorySkin.text(hud,"",635,161,300,318,12,0xffffff,"left",true);
            button("BACK","rival_back",843,14,98,backToLobby);
            GameplayAudio.preload();addEventListener(Event.ADDED_TO_STAGE,added);addEventListener(Event.ENTER_FRAME,frame);
            update();
        }
        private function added(e:Event):void {if(stage){previousFrameRate=stage.frameRate;stage.frameRate=60;stage.addEventListener(KeyboardEvent.KEY_DOWN,key);}}
        private function button(label:String,id:String,x:Number,y:Number,w:Number,fn:Function):void {
            var b:Sprite=ClassicInventorySkin.button(label,w,36,0x16669e);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{fn();});controls.addChild(b);
        }
        private function clearActions():void {for(var i:int=controls.numChildren-1;i>=0;i--)if(controls.getChildAt(i).name!="rival_back")controls.removeChildAt(i);}
        private function row(values:Array):String {return values.map(function(v:*,i:int,a:Array):String{return v===null?"—":String(v);}).join("   ");}
        private function update():void {
            if(!alive)return;var s:Object=match.state;
            score.text=match.awayTeam.name+"  "+s.away+"   —   "+s.home+"  "+match.homeTeam.name;
            lines.text="INNINGS      1   2   3   4   5   6   7   8   9\nAWAY    "+row(s.awayLine)+"     HOME    "+row(s.homeLine);
            var events:Array=s.events as Array,history:Array=[];
            for(var i:int=Math.max(0,events.length-10);i<events.length;i++){var ev:Object=events[i];history.push(ev.inning+" · "+ev.player+"  "+ev.outcome+(ev.runs?" +"+ev.runs:""));}log.text=history.join("\n");
            clearActions();
            if(s.status=="complete") {
                phase="COMPLETE";ball.hideBall();
                help.text="FINAL · "+(s.winner=="tie"?"TIE":s.winner=="home"?match.homeTeam.name+" WINS":match.awayTeam.name+" WINS")+"\n"+(s.forfeit?"Forfeit: 0–9 home loss. No individual statistics.":match.league?"Result added to the league standings.":"Result saved for both players. No season rewards.");
                button("VIEW STATISTICS","rival_box",385,641,220,showBox);return;
            }
            if(s.status=="cancelled"){phase="COMPLETE";help.text="CHALLENGE CANCELED\nNo result or rewards.";return;}
            phase="READY";ball.hideBall();batter.setPitchProgress(0);
            var bases:String=s.bases.map(function(v:*,i:int,a:Array):String{return v===null?"○":"●";}).join("  ");
            help.text="Inning "+s.inning+" / 9     OUT "+s.outs+"     B "+s.balls+" / S "+s.strikes+"     "+bases+"\n"+(s.lastCall?s.lastCall+" · ":"")+(canPlay?"Pulsa ESPACIO o PITCH. Haz swing al llegar la bola al plato.":"Tu amigo juega a su ritmo. Pulsa REFRESH para ver el avance.");
            if(canPlay){button(s.pending?"RESUME PITCH":"PITCH","rival_pitch",370,641,238,startPitch);if(!s.pending)button("AUTO TURN","rival_auto",621,641,145,autoTurn);button(match.league?"FORFEIT":"CANCEL","rival_cancel",784,641,135,confirmCancel);}
            else button("REFRESH","rival_refresh",400,641,170,refresh);
        }
        private function showBox():void {
            log.text="VISITA: AB / H / HR / RBI\n"+boxRows(match.state.box.away)+"\n\nLOCAL: AB / H / HR / RBI\n"+boxRows(match.state.box.home);log.height=460;log.y=154;log.background=true;log.backgroundColor=0x153a50;log.alpha=.97;log.setTextFormat(new TextFormat("Arial",11,0xffffff));
        }
        private function boxRows(rows:Array):String {var out:Array=[];for each(var p:Object in rows)out.push(p.name+"  "+p.ab+" / "+p.h+" / "+p.hr+" / "+p.rbi);return out.join("\n");}
        private function confirmCancel():void {if(phase!="READY")return;phase="CONFIRM";clearActions();help.text=match.league?"Forfeit this league game? A 0–9 loss will be recorded. You cannot replay it.":"Cancel this challenge? It will not count as a win or loss.";button(match.league?"FORFEIT 0–9":"YES, CANCEL","rival_cancel_confirm",390,641,190,function():void{send(match.league?"forfeit":"cancel",{});});button("CONTINUE","rival_cancel_no",600,641,170,update);}
        private function startPitch():void {if(phase!="READY"||!canPlay)return;if(match.state.pending)animatePitch();else send("pitch",{});}
        private function autoTurn():void {if(phase=="READY"&&canPlay&&!match.state.pending)send("auto",{});}
        private function animatePitch():void {phase="WINDUP";clearActions();help.text="Watch the pitch…";pitcher.throwPitch(.56);windupEnd=getTimer()+560;}
        private function frame(e:Event):void {
            if(phase=="RESULT"&&getTimer()>=resultEnd){callout.hide();update();return;}
            if(phase=="WINDUP"&&getTimer()>=windupEnd){origin=pitcher.releasePosition();ball.reset(origin.x,origin.y);pitchStart=getTimer();phase="FLIGHT";help.text=match.state.pending.kind+" · SPACE or SWING";button("SWING","rival_swing",400,641,190,hit);button("TAKE PITCH","rival_take",610,641,190,take);}
            if(phase=="FLIGHT") {
                var p:Object=match.state.pending,t:Number=Math.min(1.14,(getTimer()-pitchStart)/Number(p.duration));
                batter.setPitchProgress(t);ball.setProgress(t/.84,origin.x,origin.y,p.zone?480:586,568,Number(p.curve),p.kind=="SINKER"?20:0);
                if(t>=1.14)take();
            }
        }
        private function hit():void {if(phase!="FLIGHT")return;var elapsed:int=getTimer()-pitchStart;batter.swing(ball.y);send("swing",{pitchId:match.state.pending.id,elapsedMs:elapsed});}
        private function take():void {if(phase=="FLIGHT")send("swing",{pitchId:match.state.pending.id,elapsedMs:null});}
        private function key(e:KeyboardEvent):void {if(e.keyCode==Keyboard.SPACE){e.preventDefault();if(phase=="READY")startPitch();else if(phase=="FLIGHT")hit();}}
        private function send(action:String,body:Object):void {
            if(api.busy)return;body.requestId=OnlineClient.requestId();body.revision=match.revision;
            pendingPath="/matches/"+match.id+"/"+action;pendingBody=body;transmit();
        }
        private function transmit():void {
            if(api.busy)return;phase="WAIT";clearActions();help.text="Saving the turn…";
            api.request("POST",pendingPath,pendingBody,function(data:Object):void {
                if(!alive)return;var wasPitch:Boolean=pendingPath.substr(-6)=="/pitch";match=data;pendingBody=null;
                if(wasPitch)animatePitch();else if(match.state.status=="cancelled")update();else {
                    var call:String=match.state.lastCall,isHit:Boolean=call=="SINGLE"||call=="DOUBLE"||call=="TRIPLE"||call=="HOME RUN",automatic:Boolean=pendingPath.substr(-5)=="/auto";
                    phase="RESULT";resultEnd=getTimer()+650;help.text=call+" · turn recorded";
                    if(isHit){GameplayAudio.play(automatic?GameplayAudio.SIM_HIT:GameplayAudio.HERO_HIT);if(!automatic)ball.launchHit(call=="HOME RUN"?"PERFECT":"GOOD");}
                    else if(call=="OUT"||call=="STRIKEOUT")GameplayAudio.play(GameplayAudio.SIM_OUT);
                    else if(call=="STRIKE"||call=="FOUL")GameplayAudio.play(GameplayAudio.STRIKE);
                    callout.show(call,isHit?0xffd54a:0xffffff,40);
                }
            },error);
        }
        private function refresh():void {if(api.busy)return;phase="WAIT";clearActions();help.text="Restoring the challenge…";api.request("GET","/matches/"+match.id,null,function(data:Object):void{if(!alive)return;match=data;pendingBody=null;update();},error);}
        private function error(message:String,status:int):void {
            if(!alive)return;phase="ERROR";clearActions();help.text=message;
            if(status==401){api.forget();return;}
            if(pendingBody&&(status==0||status>=500))button("RETRY TURN","rival_retry",370,641,225,transmit);
            button("RESTORE GAME","rival_recover",615,641,230,refresh);
        }
        private function backToLobby():void {if(api.busy)return;onBack();}
        public function dispose():void {alive=false;api.dispose();removeEventListener(Event.ENTER_FRAME,frame);removeEventListener(Event.ADDED_TO_STAGE,added);if(stage){stage.removeEventListener(KeyboardEvent.KEY_DOWN,key);stage.frameRate=previousFrameRate;}batter.dispose();pitcher.dispose();ball.dispose();callout.dispose();stadium.dispose();}
    }
}
