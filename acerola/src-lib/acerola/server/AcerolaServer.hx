package acerola.server;

import acerola.server.error.AcerolaServerError;
import database.DatabaseConnection;
import node.express.Response;
import node.express.Request;
import acerola.server.route.AcerolaRoute;
import node.express.Application;
import node.express.Express;

class AcerolaServer {
    
    private var express:Application;

    public var serverStarted:Bool;
    public var route:AcerolaRoute;

    public function new(?connection:DatabaseConnection) {
        this.serverStarted = false;
        this.createApplication();
        this.route = new AcerolaRoute(this.express, connection);
    }

    private function prevent404():Void {
        this.express.get('*', this.custom404);
        this.express.post('*', this.custom404);
        this.express.put('*', this.custom404);
        this.express.delete('*', this.custom404);
    }

    private function createApplication():Void {
        this.express = Express.application();

        var cors:()->Dynamic = js.Syntax.code("require({0})", 'cors');

        this.express.use(cors());
        this.express.use(Express.urlencoded({extended:true}));
        // this.express.use(Express.raw({limit:'10mb'}));
        // this.express.use(Express.text({limit:'10mb'}));
        this.express.use(Express.json({limit:'10mb'}));
        this.express.options('*', cors());

        this.express.use(this.handleError);
    }

    public function start(port:Int = 1000):Void {
        if (this.serverStarted) return;

        Sys.println('Starting Server at port ${port}');

        this.express.listen(
            port,
            function():Void {
                this.serverStarted = true;

                Sys.println('Server running in port ${port}');
            }
        );

        this.prevent404();
    }

    function custom404(req:Request, res:Response) {
        var error:AcerolaServerError = AcerolaServerError.NOT_FOUND('Not Found', 'NOT_FOUND');
        res.setHeader('Content-Type', 'application/json');
        res.status(error.status);
        res.send(error.toData());
    }


    function handleError (err, req:Request, res:Response, next) {
        var error:AcerolaServerError = switch (err.type) {
            case 'entity.parse.failed' : AcerolaServerError.INVALID_REQUEST_DETAILED('Invalid JSON format', 'INVALID_JSON', 'INVALID_JSON');
            case _ : AcerolaServerError.SERVER_ERROR('INTERNAL_SERVER_ERROR', 'INTERNAL_SERVER_ERROR');
        }

        res.setHeader('Content-Type', 'application/json');
        res.status(error.status);
        res.send(error.toData());
    }

}