// can both 'run...' and 'test...'

import ballerina/test;
import ballerina/io;

string greeting = "Hello, World!";

function main(string... args) {
    io:println(greeting);
    int result = 0;
    int c = 3;
    int d = 4;
    result = intAdd(c,d);
    io:print(result + "\n");
}

@test:Config
function testFunc() {
    main();
    test:assertEquals(greeting,"Hello, World!",msg="string test failed");
}

function intAdd(int a, int b) returns (int) {
    return (a + b);
}

@test:Config
function testIntAdd(){
    int answer = 0;
    int a = 5;
    int b = 3;
    answer = intAdd(a, b);
    test:assertEquals(answer, 8, msg = "IntAdd function failed");
}