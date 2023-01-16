// To parse this JSON data, do
//
//     final joinLeaveDepartmentModel = joinLeaveDepartmentModelFromJson(jsonString);

import 'dart:convert';

JoinLeaveDepartmentModel joinLeaveDepartmentModelFromJson(String str) => JoinLeaveDepartmentModel.fromJson(json.decode(str));

String joinLeaveDepartmentModelToJson(JoinLeaveDepartmentModel data) => json.encode(data.toJson());

class JoinLeaveDepartmentModel {
  JoinLeaveDepartmentModel({
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
  String operationName;
  String successMessage;
  Entity entity;
  int entityStatus;
  int enumResult;
  String enumResultName;
  List<ValidationResult> validationResults;
  bool isValid;
  String errorMessages;

  factory JoinLeaveDepartmentModel.fromJson(Map<String, dynamic> json) => JoinLeaveDepartmentModel(
    successEnum: json["successEnum"] == null ? null : json["successEnum"],
    operationName: json["operationName"] == null ? null : json["operationName"],
    successMessage: json["successMessage"] == null ? null : json["successMessage"],
    entity: json["entity"] == null ? null : Entity.fromJson(json["entity"]),
    entityStatus: json["entityStatus"] == null ? null : json["entityStatus"],
    enumResult: json["enumResult"] == null ? null : json["enumResult"],
    enumResultName: json["enumResultName"] == null ? null : json["enumResultName"],
    validationResults: json["validationResults"] == null ? null : List<ValidationResult>.from(json["validationResults"].map((x) => ValidationResult.fromJson(x))),
    isValid: json["isValid"] == null ? null : json["isValid"],
    errorMessages: json["errorMessages"] == null ? null : json["errorMessages"],
  );

  Map<String, dynamic> toJson() => {
    "successEnum": successEnum == null ? null : successEnum,
    "operationName": operationName == null ? null : operationName,
    "successMessage": successMessage == null ? null : successMessage,
    "entity": entity == null ? null : entity.toJson(),
    "entityStatus": entityStatus == null ? null : entityStatus,
    "enumResult": enumResult == null ? null : enumResult,
    "enumResultName": enumResultName == null ? null : enumResultName,
    "validationResults": validationResults == null ? null : List<dynamic>.from(validationResults.map((x) => x.toJson())),
    "isValid": isValid == null ? null : isValid,
    "errorMessages": errorMessages == null ? null : errorMessages,
  };
}

class Entity {
  Entity({
    this.requestStatus,
    this.id,
    this.isValid,
  });

  int requestStatus;
  String id;
  bool isValid;

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
    requestStatus: json["requestStatus"] == null ? null : json["requestStatus"],
    id: json["id"] == null ? null : json["id"],
    isValid: json["isValid"] == null ? null : json["isValid"],
  );

  Map<String, dynamic> toJson() => {
    "requestStatus": requestStatus == null ? null : requestStatus,
    "id": id == null ? null : id,
    "isValid": isValid == null ? null : isValid,
  };
}

class ValidationResult {
  ValidationResult({
    this.memberNames,
    this.errorMessage,
  });

  List<String> memberNames;
  String errorMessage;

  factory ValidationResult.fromJson(Map<String, dynamic> json) => ValidationResult(
    memberNames: json["memberNames"] == null ? null : List<String>.from(json["memberNames"].map((x) => x)),
    errorMessage: json["errorMessage"] == null ? null : json["errorMessage"],
  );

  Map<String, dynamic> toJson() => {
    "memberNames": memberNames == null ? null : List<dynamic>.from(memberNames.map((x) => x)),
    "errorMessage": errorMessage == null ? null : errorMessage,
  };
}
