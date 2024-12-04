package project.api;

import project.api.service.test.TestGetStarService;
import acerola.server.model.AcerolaServerVerbsType;
import project.api.service.test.requests.ExampleRequests.PostDatabase;
import project.api.service.test.requests.ExampleRequests.PostTimeout;
import project.api.service.test.requests.ExampleRequests.GetHelloWorldText;
import project.api.service.test.TestGetHeaderService;
import project.api.service.test.requests.ExampleRequests.GetTestGetHeader;
import project.api.service.test.requests.ExampleRequests.PostTestPost;
import project.api.service.test.requests.ExampleRequests.GetTestGet;
import project.api.service.test.requests.ExampleRequests.GetHelloWorldJson;
import project.api.service.test.TestGetService;
import project.api.service.test.TestDatabaseService;
import database.DatabaseConnection;
import project.api.service.test.TestTimeoutService;
import project.api.service.test.TestPostService;
import project.api.service.test.HelloWorldTextService;
import project.api.service.test.HelloWorldJsonService;
import acerola.server.AcerolaServer;

class ProjectApi {
    
    static public function main() {

        var connection:DatabaseConnection = {
            host : 'mysql',
            user : 'root',
            password : 'mysql_root_password',
            port : 3306,
            max_connections: 64,
            auto_json_parse: true
        }
        
        var server:AcerolaServer = new AcerolaServer(connection);
        
        server.route.register(GetHelloWorldJson, HelloWorldJsonService);
        server.route.register(PostTestPost, TestPostService);
        server.route.register(GetTestGet, TestGetService);
        server.route.register(GetTestGetHeader, TestGetHeaderService);
        server.route.register(GetHelloWorldText, HelloWorldTextService);
        server.route.register(PostTimeout, TestTimeoutService);
        server.route.register(PostDatabase, TestDatabaseService);

        server.route.registerService(AcerolaServerVerbsType.GET, '/star/*', TestGetStarService);
        
        server.start();
        
    }
}