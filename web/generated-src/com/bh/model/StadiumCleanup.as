package com.bh.model {
 /** Per-object cooldowns use UTC milliseconds as strings, shared by local/cloud saves. */
 public class StadiumCleanup {
  public static const COINS:int=20,INTERVAL:Number=300000;
  public static function items():Array {return [{id:"bat",x:305,y:369,w:75,h:17},{id:"bat2",x:407,y:404,w:71,h:17},{id:"cleat",x:230,y:366,w:35,h:27},{id:"glove",x:326,y:414,w:31,h:22},{id:"mitt",x:491,y:389,w:44,h:33},{id:"ball",x:169,y:461,w:19,h:19}];}
  public static function create():Object {return {version:1,availableAt:{}};}
  public static function normalize(value:Object):Object {var out:Object=create(),dates:Object=value&&value.availableAt?value.availableAt:{};for each(var item:Object in items()){var at:Number=Number(dates[item.id]);if(isFinite(at)&&at>0)out.availableAt[item.id]=String(at);}return out;}
  public static function valid(id:String):Boolean {for each(var item:Object in items())if(item.id==id)return true;return false;}
  public static function ready(state:Object,id:String,now:Number):Boolean {if(!valid(id)||!isFinite(now)||now<0)return false;var at:Number=state&&state.availableAt?Number(state.availableAt[id]):0;return !isFinite(at)||at<=now;}
  public static function claim(state:Object,id:String,now:Number):int {if(!state||!ready(state,id,now))return 0;if(!state.availableAt)state.availableAt={};state.availableAt[id]=String(now+INTERVAL);return COINS;}
 }
}
