package acerola.test.api;

import apirock.ApiRock;
import apirock.types.StringKeeper;

class ApiTest {

    private var api:ApiRock;

    public function new(message:String) {

        this.api = new ApiRock(message);

        StringKeeper.clear();
        StringKeeper.addData('url', 'http://127.0.0.1:1000');
        
        this.setup();
        this.run();
    }

    private function setup():Void {

    }

    private function run():Void {
        this.api.runTests();
    }

}
