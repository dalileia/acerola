package project.api.service.test;

import database.DatabaseError;
import database.DatabaseSuccess;
import database.DatabaseRequest;
import acerola.server.service.AcerolaServerDatabaseService;

class TestDatabaseService extends AcerolaServerDatabaseService<Dynamic> {
    
    override public function run():Void {
        var query:DatabaseRequest = this.req.body;

        this.query(query, this.onComplete, onError);
    }

    private function onComplete(success:DatabaseSuccess<Dynamic>):Void {
        if (success.length == 1) {
            this.resultSuccess(success.raw.next());
        } else {
            this.resultError(null);
        }
    }

    private function onError(err:DatabaseError):Void {
        this.resultSuccess(err);
    }

}