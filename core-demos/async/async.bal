// async demo w/keywords: future, start...await, multiple threads
// to run              'ballerina run async.bal'
// result should be    'SQ + CB = 1071612'

import ballerina/io;

function main(string... args) {

    future<int> f1 = start sum(45, 57);
    int result = square_plus_cube(f1);
    io:println("SQ + CB = " + result);
}

function sum (int a, int b) returns (int) { return a + b; }

// functions can spawn multiple parallel worker threads to fork, join, and exchange data
function square_plus_cube(future<int> f) returns int {
    worker w1 {
        int n = await f;
        int sq = n*n;
        sq -> w2;  // send data to the other thread
    }
    worker w2 {
        int n = await f;
        int cb = n*n*n;
        int sq;
        sq <- w1;  // receive data from the other thread
        return sq + cb;
    }
}