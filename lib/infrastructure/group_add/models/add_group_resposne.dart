import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/new_license_response.dart';

class AddGroupResponse {
  int successEnum;
  String operationName;
  String successMessage;
  Entity entity;
  int entityStatus;
  int enumResult;
  String enumResultName;
  String validationResults;
  bool isValid;
  String errorMessages;

  AddGroupResponse(
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

  AddGroupResponse.fromJson(Map<String, dynamic> json) {
    successEnum = json['successEnum'];
    operationName = json['operationName'];
    successMessage = json['successMessage'];
    entity = json['entity'] != null ? new Entity.fromJson(json['entity']) : null;
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
    if (this.entity != null) {
      data['entity'] = this.entity.toJson();
    }
    data['entityStatus'] = this.entityStatus;
    data['enumResult'] = this.enumResult;
    data['enumResultName'] = this.enumResultName;
    data['validationResults'] = this.validationResults;
    data['isValid'] = this.isValid;
    data['errorMessages'] = this.errorMessages;
    return data;
  }
}

class Entity {
  String name;
  String description;
  String parentGroupId;
  String trainingCourseId;
  int privacyLevel;
  List<String> subCategoryIds;
  bool removeFile;
  String id;
  bool isValid;

  Entity(
      {this.name,
      this.description,
      this.parentGroupId,
      this.trainingCourseId,
      this.privacyLevel,
      this.subCategoryIds,
      this.removeFile,
      this.id,
      this.isValid});

  Entity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    parentGroupId = json['parentGroupId'];
    trainingCourseId = json['trainingCourseId'];
    privacyLevel = json['privacyLevel'];

    subCategoryIds = json['subCategoryIds'].cast<String>();

    removeFile = json['removeFile'];
    id = json['id'];
    isValid = json['isValid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['parentGroupId'] = this.parentGroupId;
    data['trainingCourseId'] = this.trainingCourseId;
    data['privacyLevel'] = this.privacyLevel;

    data['subCategoryIds'] = this.subCategoryIds;

    data['removeFile'] = this.removeFile;
    data['id'] = this.id;
    data['isValid'] = this.isValid;
    return data;
  }
}
