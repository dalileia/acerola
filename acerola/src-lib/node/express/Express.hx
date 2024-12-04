package node.express;

@:native("")
extern class Express {

	@:native("require('express')")
	static public function application():Application;

	@:native("require('express').json")
	static public function json(?options:Dynamic):(req:Request, res:Response)->Void;

	@:native("require('express').text")
	static public function text(?options:Dynamic):(req:Request, res:Response)->Void;

	@:native("require('express').text")
	static public function raw(?options:Dynamic):(req:Request, res:Response)->Void;

	@:native("require('express').urlencoded")
	static public function urlencoded(?options:Dynamic):(req:Request, res:Response)->Void;

//	public function set(name:String, value:String):Void;
//	public function listen(port:Int, ?cb:Void->Void):Void;
//
//	public function route(route:String):Router;

	//
	// @:overload(function(name:String):String{})
	// @:overload(function(name:String):Bool{})
	// public function get(name:String, callback : Request -> Response -> Void) : Void;
	// //get -> String だがbool値とundefineも返す
	// public function post(path:String, callback : Request -> Response -> Void) : Void;
	//
	// public function all(path:String, callback : Request -> Response -> (Void->Void) -> Void) : Void;
	//
	//
	// public function enable(name:String):Void;
	// public function enabled(name:String):Bool;
	// public function disable(name:String):Void;
	// public function disabled(name:String):Bool;
}