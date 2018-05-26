//Run via "ballerina run 0a_hello_world.bal"

import ballerina/io;
import ballerina/test;

string greeting = "Hello, World!";
any[] outputs = [greeting];

function main(string... args) returns (int) {
    io:println("Hello, World!");
    int num = 5; 
    return num;
}

@test:Config
function testFunc() {
    // Invoking the main function
    int num = main();
    test:assertEquals("Hello, World!", outputs[0]);
    test:assertEquals(5, num);
}