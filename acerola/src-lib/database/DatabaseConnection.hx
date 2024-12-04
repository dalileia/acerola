package database;

typedef DatabaseConnection = {
    var host:String;
    var user:String;
    var password:String;
    @:optional var auto_json_parse:Bool;
    @:optional var port:Int;
    @:optional var max_connections:Int;
    @:optional var acquire_timeout:Int;
}