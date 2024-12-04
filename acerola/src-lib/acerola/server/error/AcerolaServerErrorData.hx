package acerola.server.error;

import anonstruct.AnonStruct;

typedef AcerolaServerErrorData = {
    var status:Int;
    var message:String;
    var error_code:String;

    @:optional var internal:String;
}

class AcerolaServerErrorDataValidator extends AnonStruct {
    
    public function new() {
        super();

        this.propertyInt('status')
            .refuseNull()
            .greaterThan(0);
        
        this.propertyString('message')
            .refuseNull()
            .refuseEmpty();
        
        this.propertyString('error_code')
            .refuseNull()
            .refuseEmpty();

        this.propertyString('internal')
            .allowEmpty()
            .allowNull();
                    
    }
}