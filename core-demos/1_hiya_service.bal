// To run it: "ballerina run 1_hiya_bye.bal"
// To invoke: "curl localhost:9090/hiya/hihi"

import ballerina/http;
import ballerina/log;

@Description {value:"hiya service"}
service<http:Service> hiya bind {port:9090} {
   hihi (endpoint caller, http:Request request) {
       http:Response res;
       res.setTextPayload("Hiya World!\n");
       caller->respond(res) but { error e => log:printError(
                           "Error sending response", err = e) };
   }
}




