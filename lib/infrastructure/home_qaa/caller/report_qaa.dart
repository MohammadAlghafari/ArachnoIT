import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ReportQaa {
  final Dio dio;
  ReportQaa({@required this.dio});
  Future<dynamic> sendReport({String qaaId, String description}) async {
    final _param = {
      "itemId": qaaId,
      "reportDescription": description,
      "reportPlatformType": 0,
      "id": "00000000-0000-0000-0000-000000000000",
      "isValid": true
    };
    Response response = await dio.post(Urls.ADD_REPORT, data: _param);
    return response;
  }
}
