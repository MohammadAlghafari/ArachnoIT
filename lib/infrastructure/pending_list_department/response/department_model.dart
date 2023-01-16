import 'dart:convert';

import 'package:arachnoit/infrastructure/pendding_list_patents/response/patents_response.dart';

List<DepartmentModel> departmentModelFromJson(String str) => List<DepartmentModel>.from(json.decode(str).map((x) => DepartmentModel.fromJson(x)));

String departmentModelToJson(List<DepartmentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DepartmentModel {
  DepartmentModel({
    this.name,
    this.requestStatus,
    this.description,
    this.totalTeamMembersCount,
    this.approvedTeamMembersCount,
    this.owner,
    this.attachments,
    this.ownerId,
    this.id,
    this.isValid,
  });

  String name;
  int requestStatus;
  String description;
  int totalTeamMembersCount;
  int approvedTeamMembersCount;
  Owner owner;
  List<Attachment> attachments;
  String ownerId;
  String id;
  bool isValid;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
    name: json["name"] == null ? null : json["name"],
    requestStatus: json["requestStatus"] == null ? null : json["requestStatus"],
    description: json["description"] == null ? null : json["description"],
    totalTeamMembersCount: json["totalTeamMembersCount"] == null ? null : json["totalTeamMembersCount"],
    approvedTeamMembersCount: json["approvedTeamMembersCount"] == null ? null : json["approvedTeamMembersCount"],
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    attachments: json["attachments"] == null ? null : List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    ownerId: json["ownerId"] == null ? null : json["ownerId"],
    id: json["id"] == null ? null : json["id"],
    isValid: json["isValid"] == null ? null : json["isValid"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "requestStatus": requestStatus == null ? null : requestStatus,
    "description": description == null ? null : description,
    "totalTeamMembersCount": totalTeamMembersCount == null ? null : totalTeamMembersCount,
    "approvedTeamMembersCount": approvedTeamMembersCount == null ? null : approvedTeamMembersCount,
    "owner": owner == null ? null : owner.toJson(),
    "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
    "ownerId": ownerId == null ? null : ownerId,
    "id": id == null ? null : id,
    "isValid": isValid == null ? null : isValid,
  };

  @override
  String toString() {
    return 'DepartmentModel{name: $name, requestStatus: $requestStatus, description: $description, totalTeamMembersCount: $totalTeamMembersCount, approvedTeamMembersCount: $approvedTeamMembersCount, owner: $owner, attachments: $attachments, ownerId: $ownerId, id: $id, isValid: $isValid}';
  }
}


