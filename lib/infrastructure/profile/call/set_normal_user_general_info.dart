import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class SetNormalUserGeneralInfo {
  SetNormalUserGeneralInfo({@required this.dio});

  final Dio dio;

  Future<dynamic> setNormalUserGeneralInfo({
    String firstName,
    String lastName,
    int gender,
    String birthdate,
    String summary,
  }) async {
    print('sdnlasknd;lasnd;lasd;lnas');
    final generalInfo = {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthdate": birthdate,
      "summary": summary
    };
    Response responses =
        await dio.put(Urls.EDIT_GENERAL_INFO, data: generalInfo);
    return responses;
  }
}
