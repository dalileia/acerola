package project.api.service.test;

import acerola.server.service.AcerolaServerServiceRest;

class HelloWorldTextService extends AcerolaServerServiceRest<Dynamic> {

    override function run() {
        this.resultHtml(haxe.Json.stringify({hello : "world"}));
    }

}