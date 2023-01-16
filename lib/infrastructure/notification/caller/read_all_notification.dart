import 'dart:convert';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadAllNotification {
  final Dio dio;

  ReadAllNotification({
    this.dio,
  });

  Future<dynamic> readAllNotification({
    @required String personId,
  }) async {
    Map<String, dynamic> _param = {"PersonId": personId};
    Response response = await dio.post(
      Urls.READ_ALL_PERSON_NOTIFICATIONS,
      queryParameters: _param,
    );
    return response;
  }
}
