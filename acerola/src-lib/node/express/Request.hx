package node.express;

import js.node.http.IncomingMessage;

extern class Request extends IncomingMessage {

	public var app:Application;
	public var baseUrl:String;
	public var body:Dynamic;
	public var cookies:Dynamic;
	public var fresh:Bool;
	public var hostname:String;
	public var ip:String;
	public var ips:Array<String>;
	public var originalUrl:String;
	public var params:Dynamic;
	public var path:String;
	public var protocol:String;
	public var query:Dynamic;
	public var route:String;
	public var secure:Bool;
	public var signedCookies:Dynamic;
	public var stale:Bool;
	public var subdomains:Array<String>;
	public var xhr:Bool;

	public function get(header:String):String;
	public function is(type:String):Bool;

	@:overload(function(type:String):Void{})
	public function accepts(types:Array<String>):Void;

	public function acceptsCharsets(charset:Dynamic):Dynamic;

	public function acceptsLanguages(language:Dynamic):Dynamic;
	public function acceptsEncodings(encodeings:Dynamic):Dynamic;
}