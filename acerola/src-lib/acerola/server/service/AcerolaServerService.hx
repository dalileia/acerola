package acerola.server.service;

import acerola.server.error.AcerolaServerError;
import acerola.server.behavior.AcerolaBehaviorManager;
import anonstruct.AnonStructError;
import anonstruct.AnonStruct;
import acerola.server.model.AcerolaServerResponseData;
import acerola.server.model.AcerolaServerRequestData;

class AcerolaServerService {

    private var req:AcerolaServerRequestData;
    private var res:AcerolaServerResponseData;

    private var bodyValidator:Class<AnonStruct>;
    private var paramsValidator:Class<AnonStruct>;
    
    private var behavior:AcerolaBehaviorManager;

    public function new(req:AcerolaServerRequestData, res:AcerolaServerResponseData) {
        this.req = req;
        this.res = res;

        this.behavior = new AcerolaBehaviorManager(this.req, this.res);
    }

    public function setup():Void {
        
    }

    public function validate():Void {
        this.validateBody();
        this.validateParams();
    }

    private function validateObject(objectType:String, data:Dynamic, validator:Class<AnonStruct>):Void {
        if (validator == null) return;

        var validatorInstance = Type.createInstance(validator, []);
        
        try {
            validatorInstance.validate(data);
        } catch (e:AnonStructError) {
            throw new AcerolaServerError(400, objectType, e.toStringFriendly(), e.toString());
        } catch (e:Dynamic) {
            throw new AcerolaServerError(500, objectType, 'Undefined Error.', Std.string(e));
        }
    }

    public function validateParams():Void this.validateObject('Params', this.req.params, this.paramsValidator);
    public function validateBody():Void this.validateObject('Body', this.req.body, this.bodyValidator);

    public function run():Void {
        throw 'Override run method.';
    }

    public function runTimeout():Void {
        
    }
    
    private function result(data:Dynamic, status:Int, contentType:String):Void {
        var isSuccess:Bool = true;

        if (Std.isOfType(data, AcerolaServerError)) isSuccess = false;

        this.res.headers.set('Content-Type', contentType);
        this.res.status = status;
        this.res.data = isSuccess ? data : data.toData();
        this.res.send();

        this.runAfterResult(isSuccess);
    }

    private function runAfterResult(isSuccess:Bool):Void {
        
    }

}