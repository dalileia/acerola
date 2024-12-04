package migration;

import terminal.Terminal;
import node.mysql.Mysql;
import database.DatabaseConnection;

class Migration {

    private var mysql:MysqlConnection;
    
    public function new(connection:DatabaseConnection) {
        this.connectDatabase(connection, ()-> {});
    }

    inline private function print(message:String):Void Terminal.print('MIGRATION', message);

    private function connectDatabase(connection:DatabaseConnection, onConnect:()->Void):Void {
        if (this.mysql == null) this.mysql = Mysql.createConnection({
            host : connection.host,
            user : connection.user,
            password : connection.password,
            port : connection.port,
            charset : 'utf8mb4',
            multipleStatements : true
        });

        this.mysql.connect((err:MysqlError) -> {
            if (err != null) {
                this.print('Database Connection Error: ' + err.toString());
                haxe.Timer.delay(this.connectDatabase.bind(connection, onConnect), 2000);
                return;
            }

            this.print('Database connected!');
            onConnect();
        });
    }

    private function exit():Void {
        this.mysql.end();
        this.mysql = null;
    }

    private function query(sql:String, onResult:()->Void, onError:(message:String)->Void):Void {
        this.mysql.query(
            sql,
            (err:MysqlError, r:Dynamic, f:Array<MysqlFieldPacket>) -> {
                if (err == null) onResult();
                else onError(err.message);
            }
        );
    }


}