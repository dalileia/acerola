package acerola.test.api.hello;

class PitangaHelloWorld extends ApiTest {
    
    public function new() {
        super("Hello World");
    }

    override function setup() {
        this.api.makeRequest('Run Hello World Json')
            .GETting('#url/v1/hello-world-json')
            .mustPass()
            .makeDataAsserts({hello : "world"});

        this.api.makeRequest('Run Hello World Text')
            .GETting('#url/v1/hello-world-text')
            .mustPass()
            .makeDataAsserts('{"hello":"world"}');
    }
}