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
    // Select stock quote events w/price > 1000 within a time window of 3s.
    // Count the # of stock quotes withn the time window for a given symbol & calc the avg price of all such stock quotes.
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

        StockUpdate stockUpdate = {symbol:stockSymbol, price:stockPrice};
        inStream.publish(stockUpdate);

        http:Response res = new;
        res.statusCode = 202;
        _ = conn -> respond(res);
    }
}