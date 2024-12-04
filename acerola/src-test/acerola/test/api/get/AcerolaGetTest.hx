package acerola.test.api.get;

class AcerolaGetTest extends ApiTest {
    
    public function new() {
        super('Get Test');
    }
    override function setup() {
        this.api.makeRequest('Run Get Test')
        .GETting('#url/v1/test-get/1/world')
        .mustPass()
        .makeDataAsserts({ id: 1, hello : "world" });

        this.api.makeRequest('Run Get Test with fail')
        .GETting('#url/v1/test-get/hello/world')
        .mustFail();
        
    }

}