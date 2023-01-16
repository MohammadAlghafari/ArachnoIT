// To parse this JSON data, do
//
//     final readNotificationResponse = readNotificationResponseFromJson(jsonString);

import 'dart:convert';

ReadNotificationResponse readNotificationResponseFromJson(String str) => ReadNotificationResponse.fromJson(json.decode(str));

String readNotificationResponseToJson(ReadNotificationResponse data) => json.encode(data.toJson());

class ReadNotificationResponse {
    ReadNotificationResponse({
        this.successEnum,
        this.operationName,
        this.successMessage,
        this.entity,
        this.entityStatus,
        this.enumResult,
        this.enumResultName,
        this.validationResults,
        this.isValid,
        this.errorMessages,
    });

    int successEnum;
    dynamic operationName;
    dynamic successMessage;
    bool entity;
    int entityStatus;
    int enumResult;
    String enumResultName;
    dynamic validationResults;
    bool isValid;
    String errorMessages;

    factory ReadNotificationResponse.fromJson(Map<String, dynamic> json) => ReadNotificationResponse(
        successEnum: json["successEnum"] == null ? null : json["successEnum"],
        operationName: json["operationName"],
        successMessage: json["successMessage"],
        entity: json["entity"] == null ? null : json["entity"],
        entityStatus: json["entityStatus"] == null ? null : json["entityStatus"],
        enumResult: json["enumResult"] == null ? null : json["enumResult"],
        enumResultName: json["enumResultName"] == null ? null : json["enumResultName"],
        validationResults: json["validationResults"],
        isValid: json["isValid"] == null ? null : json["isValid"],
        errorMessages: json["errorMessages"] == null ? null : json["errorMessages"],
    );

    Map<String, dynamic> toJson() => {
        "successEnum": successEnum == null ? null : successEnum,
        "operationName": operationName,
        "successMessage": successMessage,
        "entity": entity == null ? null : entity,
        "entityStatus": entityStatus == null ? null : entityStatus,
        "enumResult": enumResult == null ? null : enumResult,
        "enumResultName": enumResultName == null ? null : enumResultName,
        "validationResults": validationResults,
        "isValid": isValid == null ? null : isValid,
        "errorMessages": errorMessages == null ? null : errorMessages,
    };
}
