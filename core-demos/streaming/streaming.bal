// from https://github.com/ballerina-guides/playground-streaming
//curl -v -X POST -d '1001.1'  "http://localhost:9090/nasdaq/publishQuote" 

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

    forever {                               // Create stream via 'forever', consume events & then x a time window
        from inStream where price > 1000    // Select stock quote events w/price > 1000
        window timeBatch(3000)              // within a time window of 3 seconds
        select symbol,          
            count(symbol) as count,         // Count the # of quotes by symbol within time window
            avg(price) as average           // Calc the avg price of given quotes
        group by symbol
        => (Result [] result) {
            resultStream.publish(result);   // Publish to resultStream & trigger stream function handlers   
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