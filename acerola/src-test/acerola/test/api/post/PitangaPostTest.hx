package acerola.test.api.post;

class PitangaPostTest extends ApiTest {
    
    public function new() {
        super("Post Test");
    }

    override function setup() {
        this.api.makeRequest('Run Post Test')
        .POSTing('#url/v1/test-post')
        .sendingJsonData('{ "hello" : "world" } ')
        .mustPass()
        .makeDataAsserts({ hello: "world" });

        this.api.makeRequest('Send malformed json')
        .POSTing('#url/v1/test-post')
        .sendingJsonData('{ "hello" : "world ')
        .mustFail()
        .makeDataAsserts({ message : "Invalid JSON format", error_code : "INVALID_JSON"});
    }
}