package project.api.service.test;

import acerola.server.service.AcerolaServerServiceRest;

class HelloWorldJsonService extends AcerolaServerServiceRest<{hello:String}> {

    override function run() {
        this.resultSuccess({hello : "world"});
    }

}