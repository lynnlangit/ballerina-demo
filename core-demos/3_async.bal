// async demo w/keywords: future, start...await, multiple threads
// to run       'ballerina run 3_async.bal'
// result is    'SQ + CB = 737100'

import ballerina/io;

function main(string... args) {

    future<int> f1 = start sum(40, 50);

    int result = square_plus_cube(f1);
    io:println("SQ + CB = " + result);
}

function sum (int a, int b) returns (int) { return a + b; }

// functions can spawn multiple parallel worker threads
// that can fork, join, and exchange data
function square_plus_cube(future<int> f) returns int {
    worker w1 {
        int n = await f;
        int sq = n*n;
        // send data to the other thread
        sq -> w2;
    }
    worker w2 {
        int n = await f;
        int cb = n*n*n;
        int sq;
        // receive data from the other thread
        sq <- w1;
        return sq + cb;
    }
}