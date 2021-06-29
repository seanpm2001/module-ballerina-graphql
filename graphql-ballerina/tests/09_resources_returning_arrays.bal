// Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

service /graphql on new Listener(9100) {
    resource function get people() returns Person[] {
        return people;
    }

    isolated resource function get ids() returns int[] {
        return [0, 1, 2];
    }

    resource function get students() returns Student[] {
        return students;
    }

    isolated resource function get allVehicles() returns Vehicle[] {
        Vehicle v1 = new("V1", "Benz", "2005");
        Vehicle v2 = new("V2", "BMW", "2010");
        Vehicle v3 = new("V3", "Ford");
        return [v1, v2, v3];
    }

    isolated resource function get searchVehicles(string keyword) returns Vehicle[]? {
        Vehicle v1 = new("V1", "Benz");
        Vehicle v2 = new("V2", "BMW");
        Vehicle v3 = new("V3", "Ford");
        return [v1, v2, v3];
    }
}

service class Vehicle {
    private final string id;
    private final string name;
    private final string? registeredYear;

    isolated function init(string id, string name, string? registeredYear = ()) {
        self.id = id;
        self.name = name;
        self.registeredYear = registeredYear;
    }

    isolated resource function get id() returns string {
        return self.id;
    }

    isolated resource function get name() returns string {
        return self.name;
    }

    isolated resource function get registeredYear() returns string?|error {
        string? registeredYear = self.registeredYear;
        if (registeredYear == ()) {
            return error("Registered Year is Not Found");
        } else {
            return self.registeredYear;
        }
    }
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testResourcesReturningScalarArrays() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ ids }";
    json actualResult = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedResult = {
        data: {
            ids: [0, 1, 2]
        }
    };
    assertJsonValuesWithOrder(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testResourcesReturningArrays() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ people { name address { city } } }";
    json actualResult = check getJsonPayloadFromService(graphqlUrl, document);

    json expectedResult = {
        data: {
            people: [
                {
                    name: "Sherlock Holmes",
                    address: {
                        city: "London"
                    }
                },
                {
                    name: "Walter White",
                    address: {
                        city: "Albuquerque"
                    }
                },
                {
                    name: "Tom Marvolo Riddle",
                    address: {
                        city: "Hogwarts"
                    }
                }
            ]
        }
    };
    assertJsonValuesWithOrder(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testResourcesReturningArraysMissingFields() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ people }";
    json actualResult = check getJsonPayloadFromBadRequest(graphqlUrl, document);

    string expectedMessage = string`Field "people" of type "[Person!]!" must have a selection of subfields. Did you mean "people { ... }"?`;
    json expectedResult = {
        errors: [
            {
                message: expectedMessage,
                locations: [
                    {
                        line: 1,
                        column: 3
                    }
                ]
            }
        ]
    };
    assertJsonValuesWithOrder(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testComplexArray() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = "{ students { name courses { name books { name } } } }";
    json actualResult = check getJsonPayloadFromService(graphqlUrl, document);
    json expectedResult = check getJsonContentFromFile("complex_array.json");
    assertJsonValuesWithOrder(actualResult, expectedResult);
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testResourceReturningServiceObjectArray() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = string `{ allVehicles { name } }`;
    json result = check getJsonPayloadFromService(graphqlUrl, document);
    json expectedPayload = {
        data: {
            allVehicles: [
                {
                    name: "Benz"
                },
                {
                    name: "BMW"
                },
                {
                    name: "Ford"
                }
            ]
        }
    };
    assertJsonValuesWithOrder(result, expectedPayload);
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testResourceReturningOptionalServiceObjectsArray() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = string `{ searchVehicles(keyword: "vehicle") { ...on Vehicle { id } } }`;
    json result = check getJsonPayloadFromService(graphqlUrl, document);
    json expectedPayload = {
        data: {
            searchVehicles: [
                {
                    id: "V1"
                },
                {
                    id: "V2"
                },
                {
                    id: "V3"
                }
            ]
        }
    };
    assertJsonValuesWithOrder(result, expectedPayload);
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testOptionalArrayInvalidQuery() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = string `{ searchVehicles(keyword: "vehicle") }`;
    json result = check getJsonPayloadFromBadRequest(graphqlUrl, document);

    json expectedPayload = {
        errors: [
            {
                message: string`Field "searchVehicles" of type "[Vehicle!]" must have a selection of subfields. Did you mean "searchVehicles { ... }"?`,
                locations: [
                    {
                        line: 1,
                        column: 3
                    }
                ]
            }
        ]
    };
    assertJsonValuesWithOrder(result, expectedPayload);
}

@test:Config {
    groups: ["array", "service"]
}
isolated function testResourceReturningServiceArrayObjectWithFragmentReturnsError() returns error? {
    string graphqlUrl = "http://localhost:9100/graphql";
    string document = string
    `{
        allVehicles {
            ...Details
        }
    }
    fragment Details on Vehicle {
        name,
        registeredYear
    }`;
    json result = check getJsonPayloadFromService(graphqlUrl, document);
    json expectedPayload = {
        data: {
            allVehicles: [
                {
                    name: "Benz",
                    registeredYear: "2005"
                },
                {
                    name: "BMW",
                    registeredYear: "2010"
                },
                {
                    name: "Ford"
                }
            ]
        },
        errors: [
            {
                message: "Registered Year is Not Found",
                locations: [
                    {
                        line: 8,
                        column: 9
                    }
                ],
                path: ["allVehicles", 2, "registeredYear"]
            }
        ]
    };
    assertJsonValuesWithOrder(result, expectedPayload);
}
