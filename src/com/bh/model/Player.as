package com.bh.model {
    public class Player {
        public var name:String; public var level:int; public var power:int; public var contact:int; public var speed:int;
        public var hits:int=0; public var hr:Number=0;
        public function Player(name:String, level:int, power:int, contact:int, speed:int) {
            this.name=name; this.level=level; this.power=power; this.contact=contact; this.speed=speed;
        }
    }
}
