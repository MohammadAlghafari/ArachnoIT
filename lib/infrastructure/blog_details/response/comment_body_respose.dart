// To parse this JSON data, do
//
//     final commentBodyRespose = commentBodyResposeFromJson(jsonString);

import 'dart:convert';

CommentBodyRespose commentBodyResposeFromJson(String str) => CommentBodyRespose.fromJson(json.decode(str));

String commentBodyResposeToJson(CommentBodyRespose data) => json.encode(data.toJson());

class CommentBodyRespose {
    CommentBodyRespose({
        this.parentId,
        this.body,
        this.id,
        this.isValid,
    });

    String parentId;
    String body;
    String id;
    bool isValid;

    factory CommentBodyRespose.fromJson(Map<String, dynamic> json) => CommentBodyRespose(
        parentId: json["parentId"] == null ? null : json["parentId"],
        body: json["body"] == null ? null : json["body"],
        id: json["id"] == null ? null : json["id"],
        isValid: json["isValid"] == null ? null : json["isValid"],
    );

    Map<String, dynamic> toJson() => {
        "parentId": parentId == null ? null : parentId,
        "body": body == null ? null : body,
        "id": id == null ? null : id,
        "isValid": isValid == null ? null : isValid,
    };
}
