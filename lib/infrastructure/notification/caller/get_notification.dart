import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetUserNotificationInfo {
  final Dio dio;

  GetUserNotificationInfo({
    @required this.dio,
  });

  Future<dynamic> getUserNotificationInfo({
    String userId,
    int pageNumber,
    int pageSize,
    bool enablePagenation,
    bool getReadOnly,
    bool getUnReadOnly,
  }) async {
    final _param = {
      "PersonId": userId,
      "pageNumber": pageNumber ?? "",
      "pageSize": pageSize ?? "",
      "EnablePagination": enablePagenation ?? "",
      "GetReadOnly": getReadOnly ?? "",
      "GetUnreadOnly": getUnReadOnly ?? "",
    };
    Response response =
        await dio.get(Urls.Get_USER_NOTIFICATION, queryParameters: _param);
    return response;
  }
}
