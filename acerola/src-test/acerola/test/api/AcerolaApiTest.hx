package acerola.test.api;

import acerola.test.api.star.AcerolaStarTest;
import acerola.test.api.get.AcerolaGetTest;
import acerola.test.api.database.AcerolaDatabaseTest;
import acerola.test.api.timeout.AcerolaTimeoutTest;
import acerola.test.api.post.PitangaPostTest;
import acerola.test.api.hello.PitangaHelloWorld;

class AcerolaApiTest {
    
    static public function main() {
        new PitangaHelloWorld();
        new PitangaPostTest();
        new AcerolaGetTest();
        new AcerolaTimeoutTest();
        new AcerolaDatabaseTest();
        new AcerolaStarTest();
    }

}