package com.bh.visual {
 /** Coordinates measured on the existing plates in their 960 x 720 presentation. */
 public class StadiumAtmosphereLayout {
  public static function create(id:String,rookie:Boolean,paidBoard:Boolean=false,neon:Boolean=false):Object {
   var p:Object={id:id,rookie:rookie,night:false,torch:false,rail:rookie,polygons:[],lights:[],flags:[[119,244,0x2879b2],[840,244,0xebbf4d]],board:{home:[427,273,28,24,18],away:[505,273,28,24,18],inning:[459,286,42,17,10],batter:[427,307,107,15,8]},ink:0xffdc68};
   if(!rookie){
    var outer:Array=[0,178,74,178,117,301,0,301],inner:Array=[148,225,329,225,350,301,170,301];
    p.lights=[[22,80],[171,128],[789,128],[938,80]];p.flags=[[130,324,0x2879b2],[830,324,0xebbf4d]];
    switch(id){
     case "stadium_background_mountain095":
      outer=[0,245,26,245,43,296,0,296];inner=[55,253,281,253,324,296,76,296];p.lights=[[67,113],[310,133],[650,133],[895,113]];
      p.board={home:[423,250,35,27,21],away:[502,250,35,27,21],inning:[465,258,31,18,10],batter:[425,281,110,12,8]};break;
     case "stadium_background_civic095":
      outer=[0,237,102,237,144,297,0,297];inner=[120,249,250,249,291,297,154,297];p.lights=[[54,94],[157,118],[237,135],[723,135],[803,118],[906,94]];
      p.board={home:[429,252,33,27,21],away:[499,252,33,27,21],inning:[467,260,29,17,10],batter:[429,281,103,12,8]};break;
     case "stadium_background_ocean":
      p.lights=[[49,77],[218,116],[720,116],[908,77]];p.flags=[[129,321,0x9a2d2b],[831,321,0x9a2d2b]];
      p.board={home:[434,233,31,24,17],away:[491,233,31,24,17],inning:[467,240,22,16,8],batter:[434,258,88,12,7]};break;
     case "stadium_background_city":
      p.night=true;outer=[0,198,75,198,117,301,0,301];inner=[150,231,331,231,350,301,172,301];p.lights=[[24,70],[171,87],[428,141],[720,87],[936,70]];
      p.board={home:[438,273,26,17,12],away:[492,273,26,17,12],inning:[467,273,23,17,8],batter:[]};break;
     case "stadium_background_triplea":
      p.lights=[[24,74],[170,112],[280,121],[530,92],[687,121],[787,112],[936,74]];
      p.board={home:[436,158,22,24,15],away:[489,158,22,24,15],inning:[462,166,23,15,8],batter:[]};break;
     case "stadium_background_holiday":
      p.night=true;p.lights=[[58,165],[167,210],[325,209],[451,103],[506,130],[635,209],[793,210],[902,165]];
      p.board={home:[442,212,22,28,18],away:[499,212,22,28,18],inning:[468,225,27,17,8],batter:[]};p.flags=[[128,324,0xb83332],[832,324,0x2e8d51]];break;
     case "stadium_background_devil":
      p.night=true;p.torch=true;p.lights=[[22,84],[172,133],[280,151],[680,151],[788,133],[938,84]];
      p.board={home:[438,263,27,23,16],away:[495,263,27,23,16],inning:[468,271,24,15,8],batter:[439,288,83,10,6]};p.flags=[[130,324,0x7b254d],[830,324,0x7b254d]];break;
     case "stadium_background_major_night":
      p.night=true;outer=[0,182,74,182,117,301,0,301];inner=[148,226,329,226,350,301,170,301];p.lights=[[24,62],[236,91],[427,63],[534,83],[748,91],[936,62]];
      p.board={home:[442,268,23,18,13],away:[492,268,23,18,13],inning:[467,269,23,17,8],batter:[]};break;
    }
    p.polygons=[outer,inner,mirror(outer),mirror(inner)];
   }else p.lights=[[54,145],[183,169],[777,169],[906,145]];
   if(paidBoard){p.screen=[424,264,112,31];p.board={home:[427,272,34,25,18],away:[499,272,34,25,18],inning:[465,297,30,12,8],batter:[427,310,106,11,7]};}
   if(neon)p.ink=0x94fff0;return p;
  }
  private static function mirror(points:Array):Array {var out:Array=[];for(var i:int=0;i<points.length;i+=2)out.push(960-points[i],points[i+1]);return out;}
 }
}
