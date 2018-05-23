// Shows annotations for @ServiceConfig & @ResourceConfig

// Run it: "ballerina run 2_annotaions.bal"
// Invoke: "curl -X POST -d "Lynn Langit" localhost:9090"

import ballerina/http;

@Description {value:"change base path via annotation"}
@http:ServiceConfig {basePath: "/"}
service<http:Service> australianGreetings bind {port:9090} {

   @Description {value:"change path with annotation and limit to POST"}
   @http:ResourceConfig {path: "/",methods: ["POST"]}
   gday (endpoint caller, http:Request request) {

       // getTextPayload return unions 'string | error'
       // Remove 'error' via 'check'
       string payload = check request.getTextPayload();
       http:Response res;
       res.setTextPayload("Gday "+payload+"!\n");
       _ = caller->respond(res);
   }
}