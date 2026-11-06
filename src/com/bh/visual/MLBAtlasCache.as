package com.bh.visual {
 import flash.display.*;import flash.events.*;import flash.filesystem.File;import flash.net.URLRequest;
 /** Load only requested sheets. Extracted views own their pixels, so LRU eviction is safe. */
 public class MLBAtlasCache {
  private static const LIMIT:int=6,CONCURRENT:int=2;
  private static var images:Object={},pending:Object={},order:Array=[],queue:Array=[],running:int=0;
  public static function fetch(sheet:String,callback:Function):void {
   if(images[sheet]){touch(sheet);callback(images[sheet]);return;}
   if(!pending[sheet]){pending[sheet]={listeners:[],started:false};queue.push(sheet);}
   pending[sheet].listeners.push(callback);pump();
  }
  public static function cancel(sheet:String,callback:Function):void {
   var task:Object=pending[sheet];if(!task)return;var i:int=task.listeners.indexOf(callback);if(i>=0)task.listeners.splice(i,1);
   if(!task.started&&!task.listeners.length)delete pending[sheet];
  }
  private static function touch(sheet:String):void {var i:int=order.indexOf(sheet);if(i>=0)order.splice(i,1);order.push(sheet);}
  private static function pump():void {
   while(running<CONCURRENT&&queue.length){var sheet:String=queue.shift();if(!pending[sheet]||pending[sheet].started)continue;start(sheet);}
  }
  private static function start(sheet:String):void {
   var task:Object=pending[sheet];task.started=true;running++;var loader:Loader=new Loader(),done:Boolean=false;
   var finish:Function=function(e:Event=null):void {
    if(done)return;done=true;loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,finish);loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,finish);loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,finish);
    var bitmap:Bitmap=loader.content as Bitmap,pixels:BitmapData;
    if(e&&e.type==Event.COMPLETE&&bitmap){pixels=bitmap.bitmapData.clone();images[sheet]=pixels;touch(sheet);}
    try{loader.unloadAndStop();}catch(error:Error){}
    var listeners:Array=task.listeners.concat();delete pending[sheet];running--;
    for each(var fn:Function in listeners)fn(pixels);
    while(order.length>LIMIT){var evicted:String=order.shift();BitmapData(images[evicted]).dispose();delete images[evicted];}pump();
   };
   loader.contentLoaderInfo.addEventListener(Event.COMPLETE,finish);loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,finish);loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,finish);
   try{loader.load(new URLRequest(File.applicationDirectory.resolvePath("assets/mlb2026/"+sheet).url));}catch(error:Error){finish();}
  }
  public static function stats():Object {return {cached:order.length,pending:queue.length,running:running,limit:LIMIT};}
 }
}
