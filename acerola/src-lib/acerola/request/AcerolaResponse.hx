package acerola.request;

import acerola.server.error.AcerolaServerErrorData;

class AcerolaResponse<RESPONSE_BODY> {
    
    public var result:RESPONSE_BODY;
    public var error:AcerolaServerErrorData;

    public var failed:Bool;

    public function new() {
        
    }
    
}