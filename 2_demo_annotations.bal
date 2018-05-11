// Shows annotations for @ServiceConfig & @ResourceConfig

// Run it: "ballerina run 2_demo_annotaions.bal"
// Invoke: "curl -X POST -d "Lynn Langit" localhost:9090"

import ballerina/http;

// Change the base path by adding annotation to the service
@http:ServiceConfig {basePath: "/"}
service<http:Service> australianGreetings bind {port:9090} {

   // Change the path by adding annotation to the resource
   // Limit the calls to POST only 
   @http:ResourceConfig {path: "/",methods: ["POST"]}
   gday (endpoint caller, http:Request request) {

       // Return from getTextPayload -  union of string | error
       // Use check to remove the error
       string payload = check request.getTextPayload();
       http:Response res;
       res.setTextPayload("Gday "+payload+"!\n");
       _ = caller->respond(res);
   }
}