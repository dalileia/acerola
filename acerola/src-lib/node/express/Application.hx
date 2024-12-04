package node.express;

extern class Application {

	public var mountpath:String;
	public var locals:String;

	public function listen(port:Int, ?callback:Void->Void):Void;

	@:overload(function(name:String):String{})
	@:overload(function(name:String):Bool{})
	@:overload(function(name:String, callback:(req:Request, res:Response)->Void):Void{})
	public function get(name:String, callback:(req:Request, res:Response, ?next:(Void)->Void)->Void):Void;

	@:overload(function(name:String, callback:(req:Request, res:Response)->Void):Void{})
	public function post(name:String, callback:(req:Request, res:Response, ?next:(Void)->Void)->Void):Void;

	@:overload(function(name:String, callback:(req:Request, res:Response)->Void):Void{})
	public function delete(path:String, callback:(req:Request, res:Response, ?next:(Void)->Void)->Void):Void;

	@:overload(function(name:String, callback:(req:Request, res:Response)->Void):Void{})
	public function put(path:String, callback:(req:Request, res:Response, ?next:(Void)->Void)->Void):Void;

	@:overload(function(name:String, callback:(req:Request, res:Response)->Void):Void{})
	public function all(path:String, callback:(req:Request, res:Response, ?next:(Void)->Void)->Void):Void;

	@:overload(function(name:String, callback:(req:Request, res:Response)->Void):Void{})
	public function options(name:String, callback:(req:Request, res:Response, ?next:(Void)->Void)->Void):Void;

	public function set(name:String, value:String):Void;

	public function enable(name:String):Void;
	public function enabled(name:String):Bool;

	public function disable(name:String):Void;
	public function disabled(name:String):Bool;

	public function param(id:String, callback:(req:Request, res:Response, ?next:(?err:Dynamic)->Void, ?id:Dynamic)->Void):Void;


	@:overload(function(option:Dynamic):Dynamic{})
	@:overload(function(?path:Dynamic,?func:Dynamic,callback:Dynamic):Dynamic{})
	@:overload(function(path:String, callback : Request -> Response -> Void) : Void{})
	@:overload(function(path:String, callback : Request -> Response -> Void, callback : Request -> Response -> Void):Void{})
	public function use(callback:Request -> Response -> Void):Void;

	public function engine(ext:String , callback : Request -> Response -> Void):Void;


	public function route(path:String):Void;
	public function render(view:String,callback : String -> String -> Void):Void;

	public function path(url:String):String;
	public function on(mount:String,callback:Request -> Void):Void;

}