package project.api.service.test;

import project.api.service.test.model.TestGetHeaderServiceData;
import acerola.server.service.AcerolaServerServiceRest;

class TestGetHeaderService extends AcerolaServerServiceRest<TestGetHeaderServiceData> {
    
    override function run() {
        var result:TestGetHeaderServiceData = {
            header : this.req.headers.get('header')
        }
        
        this.resultSuccess(result);
    }

}