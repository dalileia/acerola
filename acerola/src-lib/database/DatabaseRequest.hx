package database;

import anonstruct.AnonStruct;

typedef DatabaseRequest = {
    var query:String;

    @:optional var data:Dynamic;
    @:optional var cache:Bool;
    @:optional var cache_timeout:Int;
    @:optional var debug:Bool;
    @:optional var retry_on_deadlock:Int;
    @:optional var error:String;
    @:optional var timeout:Int;
}

class DatabaseRequestValidator extends AnonStruct {
    public function new() {
        super();

        this.propertyString('query')
            .refuseNull()
            .refuseEmpty();

        this.propertyObject('data')
            .allowNull();

        this.propertyBool('cache')
            .allowNull();

        this.propertyInt('cache_timeout')
            .refuseNull()
            .greaterOrEqualThan(0);

        this.propertyBool('debug')
            .allowNull();

        this.propertyInt('retry_on_deadlock')
            .allowNull()
            .greaterOrEqualThan(0)
            .lessOrEqualThan(10);

        this.propertyString('error')
            .refuseEmpty()
            .allowNull();

        this.propertyInt('timeout')
            .allowNull()
            .greaterOrEqualThan(0);

    }
}
