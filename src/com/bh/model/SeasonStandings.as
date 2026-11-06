package com.bh.model {
 /** Rebuild the CPU league from played rounds; opening a table never rerolls or awards anything. */
 public class SeasonStandings {
  public static function key(city:String,team:String):String {return city.toUpperCase()+"|"+team.toUpperCase();}
  private static function hash(s:String):uint {var h:uint=2166136261;for(var i:int=0;i<s.length;i++)h=uint(h*31+s.charCodeAt(i));return h;}
  private static function row(id:String,club:Object,home:Boolean):Object {return {id:id,city:club.city,teamName:club.teamName,accent:club.accent,home:home,wins:0,losses:0,played:0,pct:0,rank:0,club:club};}
  public static function build(season:int,league:int,home:Object,wins:int,losses:int,results:Array,opponent:Function):Array {
   wins=Math.max(0,Math.min(30,wins));losses=Math.max(0,Math.min(30-wins,losses));var played:int=wins+losses;
   var rows:Array=[row("HOME",home,true)],clubs:Object={},cpu:Array=[],known:Object={},n:int;
   for(n=1;n<=8;n++){var c:Object=opponent(n),id:String=key(c.city,c.teamName);if(!clubs[id]){clubs[id]=row(id,c,false);cpu.push(clubs[id]);rows.push(clubs[id]);}}
   for each(var result:Object in results||[]){if(!result||int(result.game)<1||int(result.game)>played)continue;known[int(result.game)]=result;
    if(result.opponentCity&&result.opponentTeam){id=key(result.opponentCity,result.opponentTeam);if(!clubs[id]){c=opponent(int(result.game));c.city=result.opponentCity;c.teamName=result.opponentTeam;if(result.opponentAccent!==undefined)c.accent=result.opponentAccent;clubs[id]=row(id,c,false);cpu.push(clubs[id]);rows.push(clubs[id]);}}
   }
   var knownWins:int=0,knownCount:int=0;for(var entry:String in known){knownCount++;if(known[entry].win)knownWins++;}
   var missing:int=played-knownCount,missingWins:int=Math.max(0,wins-knownWins),remainingW:int=wins,remainingL:int=losses,seed:String=season+":"+league;
   for(n=1;n<=played;n++){
    result=known[n];c=opponent(n);id=result&&result.opponentCity&&result.opponentTeam?key(result.opponentCity,result.opponentTeam):key(c.city,c.teamName);
    var rival:Object=clubs[id],win:Boolean=result?Boolean(result.win):missing>0&&hash(seed+":home:"+n)%missing<missingWins;if(!result){missing--;if(win)missingWins--;}
    if(remainingW<=0)win=false;else if(remainingL<=0)win=true;
    if(win){remainingW--;rows[0].wins++;rival.losses++;}else{remainingL--;rows[0].losses++;rival.wins++;}
    var waiting:Array=[];for each(var team:Object in cpu)if(team.id!=id)waiting.push(team);
    if(waiting.length%2==1){var bye:Object=cpu[(n-1+3)%cpu.length];if(bye.id==id)bye=cpu[(n+3)%cpu.length];for(var bi:int=0;bi<waiting.length;bi++)if(waiting[bi].id==bye.id){waiting.splice(bi,1);break;}}
    for(var j:int=waiting.length-1;j>0;j--){var at:int=hash(seed+":"+n+":shuffle:"+j)%(j+1),swap:Object=waiting[j];waiting[j]=waiting[at];waiting[at]=swap;}
    for(j=0;j+1<waiting.length;j+=2){var a:Object=waiting[j],b:Object=waiting[j+1];var edge:Number=.5+(int(hash(a.id)%21)-int(hash(b.id)%21))*.007;
     if(hash(seed+":"+n+":"+a.id+":"+b.id)%1000<edge*1000){a.wins++;b.losses++;}else{b.wins++;a.losses++;}}
   }
   for each(team in rows){team.played=team.wins+team.losses;team.pct=team.played?team.wins/team.played:0;}
   rows.sort(function(a:Object,b:Object):Number {if(a.pct!=b.pct)return a.pct>b.pct?-1:1;if(a.wins!=b.wins)return b.wins-a.wins;var ak:String=key(a.city,a.teamName),bk:String=key(b.city,b.teamName);return ak<bk?-1:ak>bk?1:0;});
   for(n=0;n<rows.length;n++)rows[n].rank=n+1;return rows;
  }
 }
}
