
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileActionRemoteDataProvider {
  final Dio dio;
  ProfileActionRemoteDataProvider({@required this.dio});
  Future<dynamic> setFollow({
  @required  String healthCareProviderId,
  @required  bool followStatus

  }) async {
    final _param = {
      "healthcareProviderId":healthCareProviderId,
      "followStatus": followStatus
    };
    Response response = await dio.put(Urls.Set_Follow_Health_Care_Provider, data: _param);
    return response;
  }
}