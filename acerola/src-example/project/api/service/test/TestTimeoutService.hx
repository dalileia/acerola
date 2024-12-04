package project.api.service.test;

import haxe.Timer;
import acerola.server.service.AcerolaServerServiceRest;

class TestTimeoutService extends AcerolaServerServiceRest<Dynamic> {
    
    override function run() {
        Timer.delay(function() {
            this.resultSuccess(true);
        }, 6000);
    }
    
}