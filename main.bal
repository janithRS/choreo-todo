import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/sql;

# A service representing a network-accessible API
# bound to port `9090`.

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

public type Item record {|
    int id;
    string content;
|};

isolated function getList() returns Item[]|error {
    final mysql:Client dbClient = check new (host = HOST, user = USER, password = PASSWORD, port = PORT, database = DATABASE);
    Item[] itemList = [];
    stream<Item, error?> itemStream = dbClient->query(
        `SELECT * FROM todo_list`
    );
    check from Item item in itemStream
        do {
            itemList.push(item);
        };
    check itemStream.close();
    check dbClient.close();
    return itemList;
}

isolated function addItem(Item item) returns int|error {
    final mysql:Client dbClient = check new (host = HOST, user = USER, password = PASSWORD, port = PORT, database = DATABASE);
    sql:ExecutionResult result = check dbClient->execute(`INSERT INTO todo_list(id, content) VALUES (${item.id}, ${item.content})`);
    int|string? lastInsertId = result.lastInsertId;
    check dbClient.close();
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}
