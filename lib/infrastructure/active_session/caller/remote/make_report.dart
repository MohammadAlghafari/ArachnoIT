import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class MakeReport {
  final Dio dio;
  MakeReport({@required this.dio});

  Future<dynamic> sendReport({String itemId,String message}) async {
    // print("the.mdlkcmasdl $itemId");
    final param = {
      "itemId": itemId,
      "reportDescription": message,
      "reportPlatformType": 8,
      "isValid": true
    };
    Response response = await dio.post(Urls.ADD_REPORT, data: param);
    return response;
  }
}
