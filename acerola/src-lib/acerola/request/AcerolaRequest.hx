package acerola.request;

import haxe.ds.StringMap;
import acerola.server.error.AcerolaServerErrorData.AcerolaServerErrorDataValidator;
import haxe.Http;
import acerola.server.model.AcerolaServerVerbsType;

class AcerolaRequest<RESPONSE_BODY, REQUEST_PARAMS, REQUEST_BODY> {
    
    public var verb:AcerolaServerVerbsType;
    public var path:AcerolaPath;

    public function new(verb:AcerolaServerVerbsType, path:AcerolaPath) {
        this.verb = verb;
        this.path = path;
    }

    public function execute(data:AcerolaRequestData<REQUEST_PARAMS, REQUEST_BODY>, response:(response:AcerolaResponse<RESPONSE_BODY>)->Void):Void {
        this.request(data.url, response, data.params, data.body, data.headers);
    }

    // TODO - accept other post body types - fixed in application/json
    private function request(domain:String, response:(response:AcerolaResponse<RESPONSE_BODY>)->Void, ?params:REQUEST_PARAMS, ?body:REQUEST_BODY, ?headers:StringMap<String>):Void {
        var url:String = domain + path.parse(params);

        var status:Int = 0;
        var http:Http = new Http(null);

        var processData:(data:String)->Dynamic = (data:String) -> {
            var result:Dynamic = data;
            var contentType:String = http.responseHeaders == null 
                ? 'application/json' 
                : http.responseHeaders.get('content-type');

            try {
                result = contentType.indexOf('application/json') != -1 ? haxe.Json.parse(data) : data;
            } catch (e) {}

            return result;
        }

        var processBodyData:(data:REQUEST_BODY)->String = (data:REQUEST_BODY) -> {
            var result:String = '';
            // var contentType:String = http.responseHeaders.get('content-type');

            result = haxe.Json.stringify(data);
            
            // try {
            //     result = contentType.indexOf('application/json') != -1 ? haxe.Json.stringify(data) : data;
            // } catch (e) {}

            return result;
        }

        http.onStatus = function(s:Int) status = s;

        http.onData = function(data:String) {
            var result = new AcerolaResponse<RESPONSE_BODY>();
            result.failed = false;
            result.result = processData(data);
            response(result);
        }

        http.onError = function(msg:String) {
            var result = new AcerolaResponse<RESPONSE_BODY>();
            result.failed = true;
            var error:Dynamic = processData(http.responseData);

            var validator:AcerolaServerErrorDataValidator = new AcerolaServerErrorDataValidator();
            if (validator.pass(error)) result.error = error;

            else result.error = {
                status : status,
                message : msg,
                error_code : 'unknown_error'
            }

            response(result);
        }

        http.setHeader('Content-Type', 'application/json');
        
        if (headers != null) for (head in headers.keys()) http.setHeader(head, headers.get(head));

        http.url = url;
        if (body != null) http.setPostData(processBodyData(body));
        http.request(this.verb == AcerolaServerVerbsType.POST ? true : false);
    }
    
}