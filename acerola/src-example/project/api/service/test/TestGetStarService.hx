package project.api.service.test;

import acerola.server.service.AcerolaServerServiceRest;

class TestGetStarService extends AcerolaServerServiceRest<Dynamic> {
    
    override function run() {
        this.resultSuccess({
            verb :  this.req.verb,
            route : this.req.route,
            path : this.req.path,
            url : this.req.url
        });
    }
    
}