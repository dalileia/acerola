package acerola.server.service;

import acerola.server.error.AcerolaServerError;
import acerola.server.model.AcerolaServerResponseData;
import acerola.server.model.AcerolaServerRequestData;

class AcerolaServerServiceRest<S> extends AcerolaServerService {

    public function new(req:AcerolaServerRequestData, res:AcerolaServerResponseData) {
        super(req, res);

        try {
            this.setup();
        } catch (e:AcerolaServerError) {
            this.resultError(e);
            return;
        } catch (e:Dynamic) {
            this.resultError(AcerolaServerError.SERVER_ERROR(Std.string(e)));
            return;
        }

        this.behavior.reset();
        this.executeBehavior();
    }

    private function executeBehavior():Void {
        if (!this.behavior.hasNext()) {
            try {
                this.validate();
                this.run();
            } catch (e:AcerolaServerError) {
                this.resultError(e);
                return;
            } catch (e:Dynamic) {
                this.resultError(AcerolaServerError.SERVER_ERROR(Std.string(e)));
                return;
            }

            return;
        }
        
        var b = this.behavior.next();
        
        b.start({
            onSuccess : this.executeBehavior,
            onError : this.resultError
        });
    }

    public function resultHtml(data:String, status:Int = 200):Void this.result(data, status, 'text/html; charset=utf-8');
    public function resultSuccess(data:S, status:Int = 200):Void this.result(data, status, 'application/json');

    public function resultError(error:AcerolaServerError):Void {
        this.result(error, error.status, 'application/json');
    }

    override private function runAfterResult(isSuccess:Bool):Void {
        this.behavior.reset();
        for (b in this.behavior) b.teardown(isSuccess);
    }

    override function runTimeout() {
        this.resultError(AcerolaServerError.SERVER_TIMEOUT('Timeout'));
    }

}