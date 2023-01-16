import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SendReplayReport {
  final Dio dio;
  SendReplayReport({@required this.dio});
  Future<dynamic> sendReport({String commentId, String description}) async {
    final _param = {
      "itemId": commentId,
      "reportDescription": description,
      "reportPlatformType": 7,
      "id": "00000000-0000-0000-0000-000000000000",
      "isValid": true
    };
    Response response = await dio.post(Urls.ADD_REPORT, data: _param);
    return response;
  }
}
