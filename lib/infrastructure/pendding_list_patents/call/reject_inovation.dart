import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class RejectPatentsInovation {
  RejectPatentsInovation({@required this.dio});
  final Dio dio;
  Future<dynamic> rejectInovations({@required String patentsId}) async {
    final _param = {"requestStatus": 3, "id": patentsId, "isValid": true};
    Response response = await dio.put(
      Urls.SET_PATENT_INIVATION,
      data: _param,
    );
    return response;
  }
}
