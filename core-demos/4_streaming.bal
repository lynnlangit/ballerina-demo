// Event streams and stream processing example
// 'Event' = occurrence that happens at a clearly defined time & is recorded in a collection of fields 
// 'Stream' = constant flow of data events

// To invoke: "curl localhost:9090/nasdaq/publishQuote"

import ballerina/http;
import ballerina/io;

type StockUpdate {string symbol;float price;};
type Result {string symbol;int count;float average;};

future f1 = start initStreamConsumer();
stream<StockUpdate> inStream;

function initStreamConsumer () {

    stream<Result> resultStream;

    resultStream.subscribe(quoteCountEventHandler);
    resultStream.subscribe(quoteAverageEventHandler);

    // Create a never-ending stream via 'forever', consumes a event stream & then processes events in motion x a time window
    // Within a time window of 3s, select the stock quote events in which the stock price is larger than 1000. 
    // Count the # of stock quotes received during the time window for a given symbol & calc the avg price of all such stock quotes.
    // Publish the result to the resultStream, which triggers the function handlers for that stream.
    forever {
        from inStream where price > 1000
        window timeBatch(3000)
        select symbol,
            count(symbol) as count,
            avg(price) as average
        group by symbol
        => (Result [] result) {
            resultStream.publish(result);
        }
    }
}

function quoteCountEventHandler (Result result) {io:println("Quote - " + result.symbol + " : count = " + result.count);}
function quoteAverageEventHandler (Result result) {io:println("Quote - " + result.symbol + " : average = " + result.average);}

endpoint http:Listener listener {port:9090};

@http:ServiceConfig {basePath: "/"}
service<http:Service> nasdaq bind listener {
    publishQuote (endpoint conn, http:Request req) {

        string reqStr = check req.getTextPayload();
        float stockPrice  = check <float> reqStr;

        string stockSymbol = "GOOG";
        // Create a record from the content of the request.
        StockUpdate stockUpdate = {symbol:stockSymbol,price:stockPrice};

        // Publish the record (event to the stream) - forever block processes these events over time.
        inStream.publish(stockUpdate);

        http:Response res = new;
        res.statusCode = 202;
        _ = conn -> respond(res);
    }
}