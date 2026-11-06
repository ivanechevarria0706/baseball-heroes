package com.bh.online {
 import flash.external.ExternalInterface;import flash.system.System;
 /** A public profile identifier, never an invitation password or session token. */
 public class FriendInvite {
  public static var pending:String="";
  public static function capture():void {try{if(ExternalInterface.available){var value:String=String(ExternalInterface.call("BHWeb.friendTarget"));pending=/^[a-f0-9]{32}$/.test(value)?value:"";}}catch(e:Error){pending="";}}
  public static function consume():String {var result:String=pending;pending="";try{if(ExternalInterface.available)ExternalInterface.call("BHWeb.clearFriendTarget");}catch(e:Error){}return result;}
  public static function link(base:String,id:String):String {return base+"/?friend="+id;}
  public static function copy(value:String):void {try{if(ExternalInterface.available)ExternalInterface.call("BHWeb.copyInvite",value);else System.setClipboard(value);}catch(e:Error){}}
 }
}
