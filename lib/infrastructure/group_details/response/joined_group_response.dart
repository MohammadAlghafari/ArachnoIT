// To parse this JSON data, do
//
//     final joinedGroupResponse = joinedGroupResponseFromJson(jsonString);

import 'dart:convert';

JoinedGroupResponse joinedGroupResponseFromJson(String str) => JoinedGroupResponse.fromJson(json.decode(str));

String joinedGroupResponseToJson(JoinedGroupResponse data) => json.encode(data.toJson());

class JoinedGroupResponse {
    JoinedGroupResponse({
        this.groupId,
        this.isValid,
        this.requestStatus,
        this.personId,
        this.encodedName,
    });

    String groupId;
    bool isValid;
    int requestStatus;
    String personId;
    String encodedName;

    factory JoinedGroupResponse.fromJson(Map<String, dynamic> json) => JoinedGroupResponse(
        groupId: json["groupId"] == null ? "null" : json["groupId"],
        isValid: json["isValid"] == null ? "null" : json["isValid"],
        requestStatus: json["requestStatus"] == null ? "null" : json["requestStatus"],
        personId: json["personId"] == null ? 'null' : json["personId"],
        encodedName: json["encodedName"] == null ? "null" : json["encodedName"],
    );

    Map<String, dynamic> toJson() => {
        "groupId": groupId == null ? "null" : groupId,
        "isValid": isValid == null ? "null" : isValid,
        "requestStatus": requestStatus == null ? "null" : requestStatus,
        "personId": personId == null ? "null" : personId,
        "encodedName": encodedName == null ? "null" : encodedName,
    };
}
