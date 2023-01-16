class DeleteGroupResponse{
  int successEnum;
  String operationName;
  String successMessage;
  bool entity;
  int entityStatus;
  int enumResult;
  String enumResultName;
  Null validationResults;
  bool isValid;
  String errorMessages;

  DeleteGroupResponse(
      {this.successEnum,
        this.operationName,
        this.successMessage,
        this.entity,
        this.entityStatus,
        this.enumResult,
        this.enumResultName,
        this.validationResults,
        this.isValid,
        this.errorMessages});

  DeleteGroupResponse.fromJson(Map<String, dynamic> json) {
    successEnum = json['successEnum'];
    operationName = json['operationName'];
    successMessage = json['successMessage'];
    entity = json['entity'];
    entityStatus = json['entityStatus'];
    enumResult = json['enumResult'];
    enumResultName = json['enumResultName'];
    validationResults = json['validationResults'];
    isValid = json['isValid'];
    errorMessages = json['errorMessages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['successEnum'] = this.successEnum;
    data['operationName'] = this.operationName;
    data['successMessage'] = this.successMessage;
    data['entity'] = this.entity;
    data['entityStatus'] = this.entityStatus;
    data['enumResult'] = this.enumResult;
    data['enumResultName'] = this.enumResultName;
    data['validationResults'] = this.validationResults;
    data['isValid'] = this.isValid;
    data['errorMessages'] = this.errorMessages;
    return data;
  }
}