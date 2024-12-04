package project.api.service.test.model;

import anonstruct.AnonStruct;

typedef TestGetServiceData = {
    var id:Int;
    var hello:String;
}

class TestGetServiceDataValidator extends AnonStruct {

    public function new() {
        super();

        this.propertyInt('id').refuseNull().greaterThan(0);
        this.propertyString('hello').refuseNull().refuseEmpty();

    }

}