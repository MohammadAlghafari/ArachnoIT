import 'dart:convert';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadUserNotificationRemoteDataProvider {
  final Dio dio;

  ReadUserNotificationRemoteDataProvider({
    this.dio,
  });

  Future<dynamic> getReadNotification({
    @required List<String> personNotificationId,
  }) async {
    Response response = await dio.post(
      Urls.READ_USER_NOTIFICATION,
      data: jsonEncode(personNotificationId),
    );
    return response;
  }
}
