package acerola.server.behavior;

import acerola.model.AcerolaCallback;
import acerola.server.model.AcerolaServerResponseData;
import acerola.server.model.AcerolaServerRequestData;

class AcerolaBehavior {
    
    public var req:AcerolaServerRequestData;
    public var res:AcerolaServerResponseData;

    public function new() {
        
    }

    public function start(cb:AcerolaCallback):Void {
        throw "Not implemented";
    }
        
    public function teardown(isSuccess:Bool):Void {
        throw "Not implemented";
    }

}