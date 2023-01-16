import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/notification/response/get_notification_response.dart';
import 'package:arachnoit/infrastructure/notification/response/notification_response.dart';
import 'package:flutter/material.dart';

abstract class NotificationInterface {
  Future<ResponseWrapper<NotificationResponseTest>> getUserNotification({
    @required String userId,
    @required int pageNumber,
    @required int pageSize,
    bool enablePagenation,
    bool getReadOnly,
    bool getUnReadOnly,
  });

   Future<ResponseWrapper<bool>>postReadNotification({
    @required List<String>  notificationId,
  });
    Future<ResponseWrapper<bool>>readAllNotifications({
    @required String personId,
  });
}
