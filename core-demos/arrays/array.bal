import ballerina/io;

function main(string... args) {
    int[] a = [];
    io:println(lengthof a);

    int[] b = [1, 2, 3, 4, 5, 6, 7, 8];
    io:println(b[0]);
    io:println(lengthof b);

    b[999] = 23;
    io:println(b[999]);
    io:println(lengthof b);

    int[][] iarray = [[1, 2, 3], [10, 20, 30], [5, 6, 7]];
    io:println(lengthof iarray);
    io:println(lengthof iarray[0]);

    iarray = [];
    int[] d = [9];
    iarray[0] = d;

    io:println(iarray[0][0]);
}