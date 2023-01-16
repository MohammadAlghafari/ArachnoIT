import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetLatestVersion {
  GetLatestVersion({@required this.dio});

  final Dio dio;

  Future<dynamic> getLatestVersion() async {
    Response response = await dio.get(Urls.GET_LATEST_VERSION_APK);
    return response;
  }
}
