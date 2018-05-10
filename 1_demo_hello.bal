// The simplest hello world REST API
// To run it: "ballerina run 1_demo_hello.bal"
// To invoke: "curl localhost:9090/hello/hi"

import ballerina/http;

service<http:Service> hello bind {port:9090} {
   hi (endpoint caller, http:Request request) {
       http:Response res;
       res.setTextPayload("Hello World!\n");
       _ = caller->respond(res);
   }
}

