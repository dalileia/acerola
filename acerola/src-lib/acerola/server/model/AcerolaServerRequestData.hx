package acerola.server.model;

import database.DatabasePool;
import acerola.request.AcerolaPath;
import datetime.DateTime;
import haxe.ds.StringMap;
import acerola.server.model.AcerolaServerVerbsType;

typedef AcerolaServerRequestData = {
    var verb:AcerolaServerVerbsType;
    var route:AcerolaPath;
    var body:Dynamic;
    var params:Dynamic;
    var headers:StringMap<String>;
    var hostname:String;
    var user_agent:String;
    var moment:DateTime;
    var pool:DatabasePool;
    var path:String;
    var url:String;
}