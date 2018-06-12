// working with configs
// 1. supply conf manually -> `ballerina run 5_configs.bal -e hello.user.name=local`
// 2a. supply var, first run -> 'export NAME=Ballerina`
// 2b. then run -> `ballerina run 5_configs.bal -e hello.user.name=@env:{NAME}`
// 3a. if `ballerina.conf' file -> can just run
// 3b. or use path to config file -> `ballerina run main.bal -c /Users/Test/Desktop/ballerina.conf`

import ballerina/io;
import ballerina/config;

function main(string... args) {
  string name = config:getAsString("hello.user.name");
  io:println("Hello, " + name + " !");
}