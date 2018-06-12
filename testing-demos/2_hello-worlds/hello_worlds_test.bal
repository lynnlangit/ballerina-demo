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
    main();
    test:assertEquals("Hello, World A!", outputs[0]);
    test:assertEquals("Hello, World B!", outputs[1]);
}