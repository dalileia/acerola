package acerola.server.service.behavior;

import acerola.server.error.AcerolaServerError;
import database.DatabaseSuccess;
import database.DatabaseError;
import database.DatabaseRequest;
import acerola.model.AcerolaCallback;
import acerola.server.behavior.AcerolaBehavior;

class AcerolaServiceBehaviorDatabase extends AcerolaBehavior {

    private var ticket:String;

    override function start(cb:AcerolaCallback) {
        this.req.pool.getTicket((ticket:String) -> {
            // TODO : Validar situacao quando o ticket nao tiver sido criado com sucesso
            this.ticket = ticket;

            cb.onSuccess();
        });
    }

    override function teardown(isSuccess:Bool):Void {
        this.req.pool.closeTicket(this.ticket, !isSuccess);
    }

    public function query<Q>(query:DatabaseRequest, onComplete:(success:DatabaseSuccess<Q>)->Void, onError:(error:DatabaseError)->Void):Void {
        this.req.pool.query(
            this.ticket,
            query,
            onComplete,
            onError
        );
    }

    public function queryRun(query:DatabaseRequest, onComplete:()->Void, onError:(err:AcerolaServerError)->Void):Void {
        this.query(
            query,
            (success:DatabaseSuccess<Dynamic>) -> onComplete(),
            (err:DatabaseError) -> {
                onError(AcerolaServerError.SERVER_ERROR(err.message));
            }
        );
    }

    public function querySelectOne<Q>(query:DatabaseRequest, onRead:(data:Q)->Void, onError:(err:AcerolaServerError)->Void):Void this.querySelect(query, true, function(data:Array<Q>):Void onRead(data[0]), onError);

    public function querySelect<Q>(query:DatabaseRequest, protectFrom404:Bool, onRead:(data:Array<Q>)->Void, onError:(err:AcerolaServerError)->Void):Void {
        this.query(
            query,
            function(success:DatabaseSuccess<Q>):Void {
                if (protectFrom404 && success.length == 0) {
                    var error:String = 'Unable to find data: ${haxe.Json.stringify(query.data)}';
                    onError(AcerolaServerError.NOT_FOUND(error));
                } else {
                    var result:Array<Q> = [];
                    for (item in success.raw) result.push(item);
                    onRead(result);
                }
            },
            (err:DatabaseError) -> {
                onError(AcerolaServerError.SERVER_ERROR(err.message));
            }
        );
    }
}