// Run via 'ballerina test 0b_hello_world_test.bal

import ballerina/test;
import ballerina/io;

any[] outputs = [];
int counter = 0;

@test:Mock {
    packageName: "ballerina.io",
    functionName: "println"
}
public function mockPrint(any... s) {
    outputs[counter] = s[0];
    counter++;
}

@test:Config
function testFunc() {
    test:assertEquals("Hello, World!", outputs[0]);
}