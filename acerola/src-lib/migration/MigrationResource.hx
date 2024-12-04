package migration;

class MigrationResource {
    
    private var path:String;
    private var data:Array<{key:String, query:String}>;
    private var migrationDatabase:String;

    public function new(path:String) {
        this.migrationDatabase = 'migration';
        this.path = path;
        this.data = [];
    }

    public function addData(key:String, query:String):Void {
        this.data.push({
            key: key,
            query: query
        });
    }

    public function loadKeyFile(key:String):Void {
        var filename = '${path}/${key}';

        if (!sys.FileSystem.exists(filename)) {
            throw 'File not found: ${filename}';
        }
        
        var query:String = sys.io.File.getContent(filename);
        this.addData(key, query);
    }

    private function getStartQuery():String {
        var result:String = '';

        result += 'SET CHARSET "utf8"; \n';
        result += 'CREATE DATABASE IF NOT EXISTS `${this.migrationDatabase}` /*!40100 DEFAULT CHARACTER SET utf8mb4 */; \n';
        result += 'CREATE TABLE IF NOT EXISTS `${this.migrationDatabase}`.`migration` (`value` VARCHAR(1024) NOT NULL COLLATE "utf8mb4_0900_ai_ci")
            COLLATE="utf8mb4_0900_ai_ci"
            ENGINE=InnoDB;
            \n
        ';

        return result;
    }

    public function getQuerySequenceAfterKey(key:String):String {
        var result:String = this.getStartQuery();
        var index:Int = this.getIndex(key);

        if (index + 1 >= this.data.length) return '';

        for (i in index + 1 ... this.data.length) {
            result += this.data[i].query;
            result += 'DELETE FROM `${this.migrationDatabase}`.`migration`; \n';
            result += 'INSERT INTO `${this.migrationDatabase}`.`migration` (`value`) VALUES ("${key}"); \n';
        }

        return result;
    }

    private function getIndex(key:String):Int {
        var result:Int = -1;

        if (key == null) result = 0;
        else {
            for (i in 0 ... this.data.length) if (this.data[i].key == key) {
                result = i;
                break;
            }

            if (result == -1) throw 'Migration key not found: ${key}';
        }

        return result;
    }

}