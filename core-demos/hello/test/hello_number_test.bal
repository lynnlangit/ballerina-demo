//Run via "ballerina run hello_number.bal"
//Test via "ballerina test hello_number.bal"

//Don't know how to test external file
//Why is main not in scope?

import ballerina/test;

@test:Config
function testFunc() {
    main();
    test:assertEquals(5, num);
}