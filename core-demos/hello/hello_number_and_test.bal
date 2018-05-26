//Run via "ballerina run hello_number.bal"
//Test via "ballerina test hello_number.bal"

import ballerina/test;
import ballerina/io;

int num;
string greeting = "Hello, World!";

function main(string... args) {
    int num = returnNum(5);
    io:println("The number is "+num);
    io:println(greeting);
}

function returnNum(int val) returns (int) {
    num = val; 
    return num;
}

@test:Config
function testFunc() {
    main();
    test:assertEquals(num, 5, msg="number test failed");
    test:assertEquals(greeting,"Hello, World!",msg="string test failed");
}