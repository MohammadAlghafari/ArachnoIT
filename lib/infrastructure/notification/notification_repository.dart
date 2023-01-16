import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/notification/caller/get_notification.dart';
import 'package:arachnoit/infrastructure/notification/notification_interface.dart';
import 'package:arachnoit/infrastructure/notification/response/get_notification_response.dart';
import 'package:arachnoit/infrastructure/notification/response/notification_response.dart';
import 'package:dio/dio.dart';
import '../api/response_type.dart' as ResType;
import 'package:flutter/material.dart';

import 'caller/get_remote_read_notification.dart';
import 'caller/read_all_notification.dart';

class NotificationRepository implements NotificationInterface {
  final GetUserNotificationInfo getUserNotificationInfo;
  final ReadUserNotificationRemoteDataProvider readUserNotificationRemoteDataProvider;
  final ReadAllNotification readAllNotification;
  NotificationRepository({
    @required this.getUserNotificationInfo,
    @required this.readUserNotificationRemoteDataProvider,
    @required this.readAllNotification,
  });
  @override
  Future<ResponseWrapper<NotificationResponseTest>> getUserNotification({
    @required String userId,
    @required int pageNumber,
    @required int pageSize,
    bool enablePagenation,
    bool getReadOnly,
    bool getUnReadOnly,
  }) async {
    try {
      Response response = await getUserNotificationInfo.getUserNotificationInfo(
        userId: userId,
        pageNumber: pageNumber,
        pageSize: pageSize,
        getReadOnly: false,
        getUnReadOnly: false,
        enablePagenation: true,
      );
      return _prepareGetNotificationInfo(remoteResponse: response);
    } on DioError catch (e) {
      print("the error is $e");
      return _prepareGetNotificationInfo(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareGetNotificationInfo(remoteResponse: null);
    }
  }

  ResponseWrapper<NotificationResponseTest> _prepareGetNotificationInfo({
    @required Response<dynamic> remoteResponse,
  }) {
    var res = ResponseWrapper<NotificationResponseTest>();
    if (remoteResponse != null) {
      res.data = NotificationResponseTest.fromJson(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<bool>> postReadNotification({
    List<String> notificationId,
  }) async {
    try {
      Response response = await readUserNotificationRemoteDataProvider.getReadNotification(
        personNotificationId: notificationId,
      );
      return _prepareReadNotificationInfo(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareReadNotificationInfo(remoteResponse: e.response);
    } catch (e) {
      return _prepareReadNotificationInfo(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareReadNotificationInfo({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      }

      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<bool>> readAllNotifications({
    String personId,
  }) async {
    try {
      Response response = await readAllNotification.readAllNotification(personId: personId);
      return _prepareReadAllNotifications(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareReadAllNotifications(remoteResponse: e.response);
    } catch (e) {
      return _prepareReadAllNotifications(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareReadAllNotifications({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    res.data = false;
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      }
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
