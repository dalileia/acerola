package acerola.server.model;

import haxe.Timer;
import haxe.ds.StringMap;

typedef AcerolaServerResponseData = {
    var headers:StringMap<String>;
    var status:Int;
    var data:Dynamic;
    var send:()->Void;
    var timeout:Timer;
}