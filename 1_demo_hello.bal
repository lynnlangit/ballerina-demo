// The simplest hello world REST API
// To run it: "ballerina run 1_demo_hello.bal"
// To invoke: "curl localhost:9090/hi/hihi"
// To invoke: "curl localhost:9091/bye/byebye"

import ballerina/http;

service<http:Service> hi bind {port:9090} {
   hihi (endpoint caller, http:Request request) {
       http:Response res;
       res.setTextPayload("Hello World!\n");
       _ = caller->respond(res);
   }
}

service<http:Service> bye bind {port:9091} {
    byebye (endpoint caller, http:Request request) {
        http: Response res;
        res.setTextPayload("Bye Bye World!\n");
        _ = caller->respond(res);
    }
}




