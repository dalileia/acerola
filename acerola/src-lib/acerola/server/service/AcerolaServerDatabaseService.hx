package acerola.server.service;

import acerola.server.error.AcerolaServerError;
import acerola.server.service.behavior.AcerolaServiceBehaviorDatabase;
import acerola.server.model.AcerolaServerResponseData;
import acerola.server.model.AcerolaServerRequestData;
import database.DatabaseSuccess;
import database.DatabaseError;
import database.DatabaseRequest;

class AcerolaServerDatabaseService<S> extends AcerolaServerServiceRest<S> {

    private var ticket:String;

    public function new(req:AcerolaServerRequestData, res:AcerolaServerResponseData) {
        super(req, res);
    }

    override function setup() {
        super.setup();
        this.behavior.addBehavior(AcerolaServiceBehaviorDatabase);
    }

    public function query<Q>(query:DatabaseRequest, onComplete:(success:DatabaseSuccess<Q>)->Void, onError:(error:DatabaseError)->Void):Void {
        this.behavior.get(AcerolaServiceBehaviorDatabase).query(
            query,
            onComplete,
            (err:DatabaseError) -> {
                if (onError == null) this.resultError(AcerolaServerError.SERVER_ERROR(err.message));
                else onError(err);
            }
        );
    }

    public function queryRun(query:DatabaseRequest, onComplete:()->Void):Void {
        this.behavior.get(AcerolaServiceBehaviorDatabase).queryRun(
            query,
            onComplete,
            this.resultError
        );
        
    }

    public function querySelectOne<Q>(query:DatabaseRequest, onRead:(data:Q)->Void):Void {
        this.behavior.get(AcerolaServiceBehaviorDatabase).querySelectOne(
            query,
            onRead,
            this.resultError
        );
    }

    public function querySelect<Q>(query:DatabaseRequest, protectFrom404:Bool, onRead:(data:Array<Q>)->Void):Void {
        this.behavior.get(AcerolaServiceBehaviorDatabase).querySelect(
            query,
            protectFrom404,
            onRead,
            this.resultError
        );
    }

    override function runAfterResult(isSuccess:Bool):Void {
        this.req.pool.closeTicket(this.ticket, !isSuccess);
        super.runAfterResult(isSuccess);
    }

}