import ballerina/http;
import ballerinax/mysql.driver as _;

# A service representing a network-accessible API
# bound to port `9090`.

service /items on new http:Listener(9090) {

    resource function get .() returns Item[]|error {
        return getList();
    }

    resource function post .(@http:Payload Item item) returns int|error? {
        return addItem(item);
    }
}
