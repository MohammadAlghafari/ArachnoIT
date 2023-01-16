import 'dart:convert';

import 'package:arachnoit/infrastructure/pendding_list_patents/response/patents_response.dart';

DepartmentByIdModel departmentByIdModelFromJson(String str) => DepartmentByIdModel.fromJson(json.decode(str));

String departmentByIdModelToJson(DepartmentByIdModel data) => json.encode(data.toJson());

class DepartmentByIdModel {
  DepartmentByIdModel({
    this.teamMembers,
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

  List<TeamMember> teamMembers;
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

  factory DepartmentByIdModel.fromJson(Map<String, dynamic> json) => DepartmentByIdModel(
    teamMembers: json["teamMembers"] == null ? null : List<TeamMember>.from(json["teamMembers"].map((x) => TeamMember.fromJson(x))),
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
    "teamMembers": teamMembers == null ? null : List<dynamic>.from(teamMembers.map((x) => x.toJson())),
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
}



class TeamMember {
  TeamMember({
    this.firstName,
    this.lastName,
    this.fullName,
    this.inTouchPointName,
    this.email,
    this.mobile,
    this.photo,
    this.position,
    this.requestStatus,
    this.healthcareProviderId,
    this.departmentId,
    this.id,
    this.isValid,
  });

  String firstName;
  String lastName;
  String fullName;
  String inTouchPointName;
  String email;
  String mobile;
  String photo;
  String position;
  int requestStatus;
  String healthcareProviderId;
  String departmentId;
  String id;
  bool isValid;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    fullName: json["fullName"] == null ? null : json["fullName"],
    inTouchPointName: json["inTouchPointName"] == null ? null : json["inTouchPointName"],
    email: json["email"] == null ? null : json["email"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    photo: json["photo"] == null ? null : json["photo"],
    position: json["position"] == null ? null : json["position"],
    requestStatus: json["requestStatus"] == null ? null : json["requestStatus"],
    healthcareProviderId: json["healthcareProviderId"] == null ? null : json["healthcareProviderId"],
    departmentId: json["departmentId"] == null ? null : json["departmentId"],
    id: json["id"] == null ? null : json["id"],
    isValid: json["isValid"] == null ? null : json["isValid"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "fullName": fullName == null ? null : fullName,
    "inTouchPointName": inTouchPointName == null ? null : inTouchPointName,
    "email": email == null ? null : email,
    "mobile": mobile == null ? null : mobile,
    "photo": photo == null ? null : photo,
    "position": position == null ? null : position,
    "requestStatus": requestStatus == null ? null : requestStatus,
    "healthcareProviderId": healthcareProviderId == null ? null : healthcareProviderId,
    "departmentId": departmentId == null ? null : departmentId,
    "id": id == null ? null : id,
    "isValid": isValid == null ? null : isValid,
  };
}
