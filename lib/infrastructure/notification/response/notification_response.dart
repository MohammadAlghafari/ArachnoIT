// To parse this JSON data, do
//
//     final notificationResponseTest = notificationResponseTestFromJson(jsonString);

import 'dart:convert';

import 'get_notification_response.dart';

List<NotificationResponseTest> notificationResponseTestFromJson(String str) => List<NotificationResponseTest>.from(json.decode(str).map((x) => NotificationResponseTest.fromJson(x)));

String notificationResponseTestToJson(List<NotificationResponseTest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationResponseTest {
    NotificationResponseTest({
        this.personNotifications,
        this.totalCount,
        this.unreadCount,
        this.readCount,
    });

    List<PersonNotification> personNotifications;
    int totalCount;
    int unreadCount;
    int readCount;

    factory NotificationResponseTest.fromJson(Map<String, dynamic> json) => NotificationResponseTest(
        personNotifications: json["personNotifications"] == null ? null : List<PersonNotification>.from(json["personNotifications"].map((x) => PersonNotification.fromJson(x))),
        totalCount: json["totalCount"] == null ? null : json["totalCount"],
        unreadCount: json["unreadCount"] == null ? null : json["unreadCount"],
        readCount: json["readCount"] == null ? null : json["readCount"],
    );

    Map<String, dynamic> toJson() => {
        "personNotifications": personNotifications == null ? null : List<dynamic>.from(personNotifications.map((x) => x.toJson())),
        "totalCount": totalCount == null ? null : totalCount,
        "unreadCount": unreadCount == null ? null : unreadCount,
        "readCount": readCount == null ? null : readCount,
    };
}
