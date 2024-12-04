package acerola.test.api.star;

class AcerolaStarTest extends ApiTest {
    
    public function new() {
        super('Star Test');
    }

    override function setup() {
        
        this.api.makeRequest('Run Star Test')
        .GETting('#url/star/hello')
        .mustPass()
        .makeDataAsserts({
            verb :  "GET",
            route : "/star/*",
            path :  "/star/hello",
            url :  "/star/hello"
        });

        this.api.makeRequest('Run Star Test with params')
        .GETting('#url/star/hello?value=world')
        .mustPass()
        .makeDataAsserts({
            verb :  "GET",
            route : "/star/*",
            path :  "/star/hello",
            url : "/star/hello?value=world"
        });

        this.api.makeRequest('Run Star Test with params')
        .GETting('#url/star/this/is/a/long/path')
        .mustPass()
        .makeDataAsserts({
            verb :  "GET",
            route : "/star/*",
            path :  "/star/this/is/a/long/path",
            url : "/star/this/is/a/long/path"
        });

    }
}