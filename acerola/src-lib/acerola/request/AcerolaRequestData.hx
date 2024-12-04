package acerola.request;

import haxe.ds.StringMap;

class AcerolaRequestData<REQUEST_PARAMS, REQUEST_BODY> {
    
    public var url:String;

    public var headers:StringMap<String>;
    public var params:REQUEST_PARAMS;
    public var body:REQUEST_BODY;
    

    public function new() {
        this.url = '';
    }

    public function setUrl(value:String):AcerolaRequestData<REQUEST_PARAMS, REQUEST_BODY> {
        this.url = value;
        return this;
    }

    public function setParams(value:REQUEST_PARAMS):AcerolaRequestData<REQUEST_PARAMS, REQUEST_BODY> {
        this.params = value;
        return this;
    }

    public function setBody(value:REQUEST_BODY):AcerolaRequestData<REQUEST_PARAMS, REQUEST_BODY> {
        this.body = value;
        return this;
    }

    public function setHeader(header:String, value:String):AcerolaRequestData<REQUEST_PARAMS, REQUEST_BODY> {
        if (this.headers == null) headers = new StringMap<String>();
        this.headers.set(header, value);
        
        return this;
    }

}