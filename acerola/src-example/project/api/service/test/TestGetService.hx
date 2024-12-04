package project.api.service.test;

import project.api.service.test.model.TestGetServiceData;
import acerola.server.service.AcerolaServerServiceRest;

class TestGetService extends AcerolaServerServiceRest<TestGetServiceData> {
    
    override function setup() {
        this.paramsValidator = TestGetServiceDataValidator;
    }

    override function run() {
        var params:TestGetServiceData = this.req.params;        
        this.resultSuccess(params);
    }

}