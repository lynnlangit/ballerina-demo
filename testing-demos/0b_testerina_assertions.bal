// Run via 'ballerina test...'

import ballerina/test;

@test:Config
function testAssertIntEquals() {

    int answer = 0;
    int a = 5;
    int b = 3;
    answer = intAdd(a, b);
    test:assertEquals(answer, 8, msg = "IntAdd function failed");
}

@test:Config
function testAssertFloatEquals() {
    float a = 10.000;
    float b = 20.050;
    float answer = floatAdd(a, b);
    test:assertEquals(answer, 30.050, msg = "FloatAdd function failed");
}

@test:Config
function testAssertStringEquals() {
    string a = "John";
    string b = "Doe";
    string concatenated = stringConcat(a, b);
    test:assertEquals(concatenated, "JohnDoe", msg = "String concat failed");
}

@test:Config
function testAssertJsonEquals() {

    json a = { "name": "Ballerina" };
    json b = { "name": "Ballerina" };
    test:assertEquals(a, b, msg = "JSON assert equals failed");
}

@test:Config
function testAssertBooleanEquals() {

    boolean x = true;
    boolean y = true;
    test:assertEquals(x, y, msg = "AssertBooleanEquals failed");
}

@test:Config
function testAssertStringArrayEquals() {

    string[] x = ["A", "B", "C"];
    string[] y = ["A", "B", "C"];

    test:assertEquals(x, y, msg = "String arrays are not equal");
}

@test:Config
function testAssertIntArrayEquals() {

    int[] x = [1, 2, 3];
    int[] y = [1, 2, 3];

    test:assertEquals(x, y, msg = "Int arrays are not equal");
}

@test:Config
function testAssertFloatArrayEquals() {

    float[] x = [1.1, 2.2, 3.3];
    float[] y = [1.1, 2.2, 3.3];

    test:assertEquals(x, y, msg = "Failed");
}

@test:Config
function testAssertNotEqualsString() {

    string s1 = "abc";
    string s2 = "def";

    test:assertNotEquals(s1, s2, msg = "Strings are equal");
}

@test:Config
function testAssertNotEqualsJson() {

    json s1 = { "a": "b" };
    json s2 = { "a": "c" };

    test:assertNotEquals(s1, s2, msg = "JSON are equal");
}

@test:Config
function testAssertTrue() {
    boolean value = true;
    test:assertTrue(value, msg = "AssertTrue failed");
}

@test:Config
function testAssertFalse() {

    boolean value = false;
    test:assertFalse(value, msg = "AssertFalse failed");
}

// Intentionally failing a test.
@test:Config
function testAssertFail1() {
    try {
        // I'm expecting an error
        test:assertFail(msg = "Exception Never occured");

    } catch (error e) {
        // Do more assertions
    }
}

// Intentionally failing a test-example 2.
@test:Config
function testAssertFail2() {
    if (true) {
        return;
    }
    test:assertFail(msg = "AssertFailed");
}

function intAdd(int a, int b) returns (int) {
    return (a + b);
}

function floatAdd(float a, float b) returns (float) {
    return (a + b);
}

function stringConcat(string a, string b) returns (string) {
    return (a + b);
}