package acerola.server.behavior;

import acerola.server.model.AcerolaServerResponseData;
import acerola.server.model.AcerolaServerRequestData;
import haxe.ds.StringMap;

class AcerolaBehaviorManager {

    private var map:StringMap<Int>;
    private var behaviors:Array<AcerolaBehavior>;
    
    private var req:AcerolaServerRequestData;
    private var res:AcerolaServerResponseData;

    private var i:Int;

    public function new(req:AcerolaServerRequestData, res:AcerolaServerResponseData) {
        this.i = 0;

        this.req = req;
        this.res = res;

        this.map = new StringMap<Int>();
        this.behaviors = [];
    }

    public function reset():Void this.i = 0;
    
    public function hasNext():Bool return i < this.behaviors.length;
    public function next():AcerolaBehavior return this.behaviors[i++];
    
    public function addBehavior(behavior:Class<AcerolaBehavior>):Void {
        var behaviorInstance:AcerolaBehavior = Type.createInstance(behavior, []);
        behaviorInstance.req = this.req;
        behaviorInstance.res = this.res;
        
        var behaviorClassName:String = Type.getClassName(behavior);
        this.map.set(behaviorClassName, this.behaviors.length);
        this.behaviors.push(behaviorInstance);
    }

    public function get<T:Class<R>, R:AcerolaBehavior>(behavior:T):R {
        var behaviorClassName:String = Type.getClassName(behavior);
        return cast this.behaviors[this.map.get(behaviorClassName)];
    }

}