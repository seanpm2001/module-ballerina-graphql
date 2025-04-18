/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.graphql.compiler.validator.errors;

import static io.ballerina.stdlib.graphql.compiler.validator.ValidatorUtils.DOUBLE_UNDERSCORES;
import static io.ballerina.stdlib.graphql.compiler.validator.ValidatorUtils.RESOURCE_FUNCTION_GET;

/**
 * Compilation error messages used in Ballerina GraphQL package compiler plugin.
 */
public enum ErrorMessage {
    ERROR_101("Remote methods are not allowed inside the service classes returned from GraphQL resources"),
    ERROR_102("Invalid GraphQL field Type"),
    ERROR_103("Invalid GraphQL input parameter type `{0}`"),
    ERROR_104("A GraphQL field must have a return type"),
    ERROR_105("A GraphQL field must have a return data type"),
    ERROR_106("Only \"" + RESOURCE_FUNCTION_GET + "\" accessor is allowed for GraphQL resource function"),
    ERROR_107("A GraphQL service cannot be attached to multiple listeners"),
    ERROR_108("A GraphQL field must have a return data type"),
    ERROR_109("http:Listener and graphql:ListenerConfiguration are mutually exclusive"),
    ERROR_110("Invalid GraphQL union type member. Only distinct service types are allowed"),
    ERROR_111("A GraphQL field name must not begin with \"" + DOUBLE_UNDERSCORES +
                      "\", which is reserved by GraphQL introspection"),
    ERROR_112("A GraphQL field cannot have \"any\" or \"anydata\" as the type, instead use specific types"),
    ERROR_113("A GraphQL service must have at least one resource function"),
    ERROR_114("A GraphQL field cannot use an input type as an output type"),
    ERROR_115("A GraphQL field cannot use an output type as an input type"),
    ERROR_116("The graphql:Context should be the first parameter"),
    ERROR_117("Path parameters not allowed in GraphQL resources"),
    ERROR_118("A GraphQL resource must have a name"),
    ERROR_119("The graphql:Upload cannot be used as an input type of resource function"),
    ERROR_120("GraphQL input cannot have multi-dimensional graphql:Upload arrays"),
    ERROR_121("Graphql input type must not be a subtype of `error?`"),
    ERROR_122("Invalid union type for GraphQL input type"),
    ERROR_123("Invalid intersection type for GraphQL type");

    private final String message;

    ErrorMessage(String message) {
        this.message = message;
    }

    public String getMessage() {
        return this.message;
    }
}
