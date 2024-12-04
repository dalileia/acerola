package node.express;

extern class Response{

	public var locals:Dynamic;

	public function status(num:Int):Response;
	public function set(name:String, value:String): Void;
	public function get(type:String):String;
	public function cookie(name:String,tobi:Dynamic,option:Dynamic):Void;
	public function clearCookie(name:String,option:Dynamic):Void;
	public function redirect(path:String):Dynamic;
	public function location(path:String):Dynamic;
	public function send(option:Dynamic):Dynamic;
	public function json(option:Dynamic):Dynamic;
	public function jsonp(option:Dynamic):Dynamic;
	public function type(type:String):Void;
	public function format(option:Dynamic):Void;
	public function setHeader(key:String, value:String):Void;
	public function getHeader(key:String):String;
	public function attachment():Void;
	public function sendStatus(status:Int):Void;
	public function sendFile(path:String,?option:Dynamic,?callback:Dynamic):Dynamic;
	public function download(filename:String):Dynamic;
	public function links(links:Dynamic):Void;
	public function render(path:String,callback:Dynamic->Dynamic->Void):Void;
	public function vary(option:String):Void;
	public function end():Void;
	public var headersSent:Dynamic;
}
