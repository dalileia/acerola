package project.api.service.test;

import project.api.service.test.model.TestPostServiceData;
import acerola.server.service.AcerolaServerServiceRest;

class TestPostService extends AcerolaServerServiceRest<TestPostServiceData> {
    
    override function run() {
        var data:Dynamic = this.req.body;
        this.resultSuccess(data);
    }

}