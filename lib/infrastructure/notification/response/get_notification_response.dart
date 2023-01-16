// To parse this JSON data, do
//
//     final notificationResponse = notificationResponseFromJson(jsonString);

import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) => json.encode(data.toJson());

class NotificationResponse {
    NotificationResponse({
        this.personNotifications,
    });

    List<PersonNotification> personNotifications;

    factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
        personNotifications: json["personNotifications"] == null ? null : List<PersonNotification>.from(json["personNotifications"].map((x) => PersonNotification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "personNotifications": personNotifications == null ? null : List<dynamic>.from(personNotifications.map((x) => x.toJson())),
    };
}

class PersonNotification {
    PersonNotification({
        this.notificationId,
        this.requestData,
        this.responseData,
        this.notificationType,
        this.isRead,
    });

    String notificationId;
    String requestData;
    dynamic responseData;
    String notificationType;
    bool isRead;

    factory PersonNotification.fromJson(Map<String, dynamic> json) => PersonNotification(
        notificationId: json["notificationId"] == null ? null : json["notificationId"],
        requestData: json["requestData"] == null ? null : json["requestData"],
        responseData: json["responseData"],
        notificationType: json["notificationType"] == null ? null : json["notificationType"],
        isRead: json["isRead"] == null ? null : json["isRead"],
    );

    Map<String, dynamic> toJson() => {
        "notificationId": notificationId == null ? null : notificationId,
        "requestData": requestData == null ? null : requestData,
        "responseData": responseData,
        "notificationType": notificationType == null ? null : notificationType,
        "isRead": isRead == null ? null : isRead,
    };
}
