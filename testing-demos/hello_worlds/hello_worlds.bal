import ballerina/io;

string greetingA = "Hello, World A!";
string greetingB = "Hello, World B!";

function main(string... args) {
    io:println(greetingA);
    io:println(greetingB);
}