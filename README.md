# Ballerina Language Demos

### Get Ballerina

 - Download from [ballerina.io](http://ballerina.io)
 - Currently tested on 0.970.0
 - Add Ballerina **bin** folder to your $PATH
 - Check it by opening the terminal window and running:

```
$ ballerina version
Ballerina 0.970.0
```

### Get Tools - VS Code, Curl & Docker

 - Install VS Code: [https://code.visualstudio.com/](https://code.visualstudio.com/)
 - Download curl from: [https://curl.haxx.se/download.html](https://curl.haxx.se/download.html) 
 - Install Ballerina plug-in by importing the VSIX file:

![image alt text](img/image_0.png)

```
 - Set the 'ballerina.home' path:
{
   "window.zoomLevel": 0,
   "editor.fontSize": 24,
   "terminal.integrated.fontSize": 24,
   "ballerina.home": "/Users/lynnlangit/Ballerina/distro/"
}
```

![image alt text](img/image_1.png)

![image alt text](img/image_2.png) 

 - Install Docker with Kubernetes (this requires Edge edition with Kubernetes enabled): [https://blog.docker.com/2018/01/docker-mac-kubernetes/](https://blog.docker.com/2018/01/docker-mac-kubernetes/) 

Demo tested on:

![image alt text](img/image_3.png)


###  Folders & Files

The structure described below is currently required by the VS Code plug-in to properly work. It makes it think that demo.bal is in the demo package. If you have multiple other files with different names or from other folders, you might lose code completion.

Create a new empty folder: e.g. Meetup-May-02-2018:

* Create two folders in it: .ballerina and demo (this is needed for VS Code tab completion to work properly, the latter folder should have the same name as the .bal file that you will be using),
* In the demo folder:
    * create demo.bal
    * Copy twitter.toml (see the Twitter section above),
    
Your folder structure should look like:

```
$ tree -a
.
├── .ballerina
└── demo
    ├── demo.bal
    └── twitter.toml
```

In the terminal window and in the VS Code terminal window go to your newly created folder and verify that you have the files:

```
$ cd demo
$ ls
demo.bal
twitter.toml
```

## DEMOS -  Hello World

In VS Code’s Terminal pane run:

```
$ ballerina run demo.bal
ballerina: initiating service(s) in 'demo.bal'
ballerina: started HTTP/WS endpoint 0.0.0.0:9090
```

Now you can invoke the service in the Terminal window:

```
$ curl localhost:9090/hello/hi
Hello World!
```
You now have a Hello World REST service running and listening on port 9090.

Go back to VS Code terminal pane and kill the service by pressing Ctrl-C.

## DEMO - Annotations

We want the service to just be there at the root path / - so let’s add ServiceConfig to overwrite the default base path (which is the service name). Add the following annotation right before the service:

```ballerina
@http:ServiceConfig {
   basePath: "/"
}
```

Make the resource available at the root as well and change methods to POST - we will pass some parameters!  

```ballerina
   @http:ResourceConfig {
       methods: ["POST"],
       path: "/"
   }
```

In the hello function, get the payload as string (filter out possible errors):

```ballerina
       string payload = check req.getTextPayload();
```

Then add the name into the output string:

```ballerina
      response.setTextPayload("Hello " + payload + "!\n");
```

Your final code should be (see comments for the new lines that you add at this stage):

```ballerina
// Add annotations for @ServiceConfig & @ResourceConfig
// to provide custom path and limit to POST
// Get payload from the POST request
// To run it:
// ballerina run demo.bal
// To invoke:
// curl -X POST -d "Demo" localhost:9090

import ballerina/http;

// Add this annotation to the service to change the base path
@http:ServiceConfig {
  basePath: "/"
}

service<http:Service> hello bind {port:9090} {

  // Add this annotation to the resource to change its path
  // and to limit the calls to POST only
  @http:ResourceConfig {
      path: "/",
      methods: ["POST"]
  }

  hi (endpoint caller, http:Request request) {

      // extract the payload from the request
      // getTextPayload actually returns a union of string | error
      // we will show how to handle the error later in the demo
      // for now, just use check that "removes" the error
      // (in reality, if there is error it will pass it up the caller stack)
      string payload = check request.getTextPayload();
      
      http:Response res;

      // use it in the response
      res.setTextPayload("Hello "+payload+"!\n");

      _ = caller->respond(res);
  }
}
```

Run it again and invoke this time as POST:

```
$ curl -X POST -d "Ballerina" localhost:9090
Hello Ballerina!
```

## DEMO - Connectors

Ballerina Central is the place where the Ballerina community is sharing those. WSO2 is one of the contributors. Let’s work with Twitter with the help of the WSO2/twitter package. Search for the package:

```
$ ballerina search twitter
```
```
$ ballerina pull wso2/twitter
```

In the code, add:

```ballerina
import wso2/twitter;
```
Import config so we can read from the config file:

```ballerina
import ballerina/config;
```

This code would be right below the import:

```ballerina
endpoint twitter:Client tw {
   clientId: config:getAsString("clientId"),
   clientSecret: config:getAsString("clientSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret"),
   clientConfig:{}   
};
```

Now we have the twitter endpoint in our hands, let’s go ahead and tweet!  See the 'twitter-demos' README.md for details.


# Intro slides

## Slide deck

[Ballerina Overview and Demo.pptx](https://docs.google.com/presentation/d/1yuixfusHrICWn6nxRobDEMjuWaHvn3qMJMzQnjNIkMk/edit?usp=sharing)

### Slide 1 

Crazy customer demand has led to the rise of companies like Google, Uber, and Amazon. They have had to build complex systems to meet customer demand.  If you look at how those companies have evolved, they have increasingly disaggregated their architectures in order to scale. 

This is a continuation of a trend that we have seen over five decades. Massively disaggregated approaches like microservices, serverless, and APIs are becoming the norm for us all.

### Slide 2 (picture explains dealing with multiple endpoints is integration)
Integration in a disaggregate world

We have seen these disaggregated components become network accessible. We call them endpoints. Whether it is data, apps, APIs, microservices, or serverless functions, everything is becoming a programmable endpoint. The number of endpoints is exploding. 

### Slide 3 (Integration challenges)

The apps we will write increasingly depend on these endpoints. Integration is the discipline of resilient communication between endpoints. It isn’t easy. The challenges include compensation, transactions, events, circuit breakers, discovery, and protocol handling, and mediation. These are all hard problems. 

### Slide 4 part 1 (ESBs etc on the left)

There have been two ways to handle integration. 

One approach to scale integration has used integration products based on configuration, not code. We’ve created EAI, ESBs, XML configurations and DSLs, Business process workflow servers and many more.

### Slide 4 part 2 (box them with "not agile")

There’s only one problem. These approaches aren’t **agile. **They disrupt the edit, build, run, test cycle. And that isn’t the experience we desire as developers.

### Slide 4 part 3 (add the agile technologies)

The other way to do integration is with general purpose programming languages. These have developed to provide agility and to enhance developer workflow. 

### Slide 4 part 4 (box agile with "not integration simple")

With these programming languages, developers have to take responsibility for solving the hard problems of integration. They do this by writing their own integration logic or by using complex bolt-on frameworks. This approach is agile, but not **integration simple. **

### Slide 4 part 5 (integration gap)

That leads to our fundamental problem - you can have integration simple or agile, but not both. This is the **integration gap.** 

Our team has worked on thousands of integration projects over two decades. We’ve seen and used almost every integration technique out there.. Those projects have always ended up on one side or the other of the integration gap.

### Slide 5 - Ballerina

Three years ago, we set out to overcome this problem. The result is Ballerina. Ballerina is a programming language and a platform. We co-designed the runtime and language together: and we believe that this has created a new approach that is both agile and integration simple. Let’s take a look and see what that looks like.




