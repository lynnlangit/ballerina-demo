//Run via "ballerina run hello_number.bal"
//Test via "ballerina test hello_number.bal"

import ballerina/test;

int num;

function main(string... args) {
    int num = returnNum(5);
}

function returnNum(int val) returns (int) {
    num = val; 
    return num;
}

@test:Config
function testFunc() {
    main();
    test:assertEquals(5, num);
}