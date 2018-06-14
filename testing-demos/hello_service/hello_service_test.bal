import ballerina/http;
import ballerina/log;
import ballerina/test;
import ballerina/io;

boolean isHelloServiceStarted;

function startMock () {isHelloServiceStarted = test:startServices("mock");}
function stopMock () {test:stopServices("mock");}

@test:Config{before: "startMock",after:"stopMock"}
function testService () {endpoint http:Client httpEndpoint {url:"http://0.0.0.0:9092"};

    test:assertTrue(isHelloServiceStarted, msg = "Hello service failed to start");

    var response = httpEndpoint -> get("/hello");
    match response {
        http:Response resp => {
            var jsonRes = resp.getJsonPayload();
            json expected = {"Hello":"World"};
            test:assertEquals(jsonRes, expected);
        // http:HttpConnectorError err => test:assertFail(msg = "Failed to call the endpoint: " + uri);
        http:HttpConnectorError err;  
        }
    }

// The service we are going to start and test
endpoint http:Listener helloEP {port: 9092};

@http:ServiceConfig {basePath: "/hello"}
service<http:Service> HelloServiceMock bind helloEP {

    @http:ResourceConfig {methods:["GET"],path:"/"}
    getEvents (endpoint caller, http:Request req) {
        http:Response res = new;
        json j = {"Hello":"World"};
        res.setJsonPayload(j);
        _ = caller -> respond(res);
    }
}

// @Description {value:"hiya service"}
// service<http:Service> hiya bind {port:9090} {
//    hihi (endpoint caller, http:Request request) {
//        http:Response res;
//        res.setTextPayload("Hiya World!\n");
//        caller->respond(res) but { error e => log:printError(
//                            "Error sending response", err = e) };
//    }
}






