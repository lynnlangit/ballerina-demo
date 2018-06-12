// Move all the invocation and tweeting functionality to another function
// call it asynchronously

// Run it: `ballerina run 8_demo_async_tweet.bal --config twitter.toml`
// Invoke: `curl -X POST localhost:9090`
// Invoke many times to show how quickly the function returns
// then go to the browser and refresh a few times to see how gradually new tweets appear

import ballerina/http;
import wso2/twitter;
import ballerina/config;

endpoint twitter:Client tw {
  clientId: config:getAsString("clientId"),
  clientSecret: config:getAsString("clientSecret"),
  accessToken: config:getAsString("accessToken"),
  accessTokenSecret: config:getAsString("accessTokenSecret"),
  clientConfig: {}  
};

endpoint http:Client homer {
  url: "http://www.simpsonquotes.xyz"
};

@http:ServiceConfig {basePath: "/"}
service<http:Service> australianStatus bind {port: 9090} {

  @http:ResourceConfig {path: "/",methods: ["POST"]}
  noWorries (endpoint caller, http:Request request) {

      // Start keyword calls asynchronously
      _ = start doTweet();

      http:Response res;
      res.setTextPayload("Async call\n"); 

      _ = caller->respond(res);
  }
}

function doTweet() {

    // Remove all error handling here due to async call
    http:Response hResp = check homer->get("/quote");
    string payload = check hResp.getTextPayload();

    if (!payload.contains("#ballerina")){ 
      payload = payload+" #ballerina"; 
      }
      
    _ = tw->tweet(payload);
}