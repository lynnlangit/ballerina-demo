// Add twitter connector: import, create endpoint, create a new resource that invoke it
// To find it: http://central.ballerina.io use `ballerina search twitter`
// To get it for tab completion: `ballerina pull wso2/twitter`
// To run it: `ballerina run demo.bal --config twitter.toml`
// To invoke: `curl -X POST -d "Demo" localhost:9090`

import ballerina/http;
import wso2/twitter;
import ballerina/config;

// Define endpoint from twitter package (incorporates the twitter API)
// Initialize it with OAuth data from apps.twitter.com
// Read confidential data from a *.toml file
endpoint twitter:Client tw {
   clientId: config:getAsString("clientId"),
   clientSecret: config:getAsString("clientSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret"),
   clientConfig: {}   
};

@http:ServiceConfig {
   basePath: "/"
}
service<http:Service> hello bind {port:9090} {
   @http:ResourceConfig {
       path: "/",
       methods: ["POST"]
   }
   hi (endpoint caller, http:Request request) {
       http:Response res;
       string payload = check request.getTextPayload();
       twitter:Status st = check tw->tweet(payload);
       res.setTextPayload("Tweeted: " + st.text + "\n");
       _ = caller->respond(res);
   } 
}