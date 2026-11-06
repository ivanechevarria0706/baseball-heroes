package com.bh.model {
    /** Session-only social presentation cache; never changes a career or awards gifts. */
    public class FriendRoster {
        private static var members:Array=[];
        public static var ready:Boolean=false;
        public static function update(snapshot:Object):void {
            if(!snapshot||!(snapshot.members is Array))return;
            members=[];
            for each(var m:Object in snapshot.members)if(m&&m.connected===true&&m.id is String&&m.name is String)
                members.push({id:m.id,name:m.name,profile:m.profile||{},team:m.team});
            members.sortOn("name",Array.CASEINSENSITIVE);ready=true;
        }
        public static function list():Array {return JSON.parse(JSON.stringify(members)) as Array;}
        public static function find(id:String):Object {for each(var m:Object in list())if(m.id==id)return m;return null;}
    }
}
