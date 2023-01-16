import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetProfileInfo {
  final Dio dio;
  GetProfileInfo({@required this.dio});
  Future<dynamic> getUserProfileInfo({String userId}) async {
    final _param = {"userId": userId};
    Response response = await dio.get(Urls.GET_PROFILE_INFO, queryParameters: _param);
    return response;
  }
}