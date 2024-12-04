package acerola.test.api.timeout;

class AcerolaTimeoutTest extends ApiTest {
    
    public function new() {
        super("Timeout Test");
    }

    override function setup() {
        this.api.makeRequest('Run Timeout Test')
        .POSTing('#url/v1/timeout')
        .mustDoCode(504);
    }
}