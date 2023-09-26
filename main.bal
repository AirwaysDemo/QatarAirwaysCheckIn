import ballerinax/mysql;
import ballerina/http;
import ballerinax/mysql.driver as _;
import ballerina/io;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new (
    host = HOST, user = USER, password = PASSWORD,  database = DATABASE
);

service /qatarairways on new http:Listener(9090) {
    resource function post checkin(@http:Payload Request request) returns json|error {
        CheckIn|error result = getCheckin(request.passengerName, request.bookReference);

        if (result is CheckIn) {
            io:print(result);
            return result;
        }
        else {
            return {
            "customerId": "null",
        "flightNumber": "null",
        "seatNumber": "null",
        "passengerName": "null",
        "fromWhere": "null",
        "whereTo": "null",
        "flightDistance": 0.0
        };
        }

    }
}

function getCheckin(string passengerName, string bookReference) returns CheckIn|error {
    return check dbClient->queryRow(
        `SELECT customerId,flightNumber,seatNumber,passengerName,fromWhere,whereTo,flightDistance FROM qatarCheckin WHERE passengerName = ${passengerName} AND bookReference = ${bookReference}`
    );
}

