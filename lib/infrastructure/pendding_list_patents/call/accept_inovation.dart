import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AcceptPatentsInovation {
  AcceptPatentsInovation({@required this.dio});
  final Dio dio;
  Future<dynamic> acceptInovations({@required String patentsId}) async {
    final _param = {"requestStatus": 1, "id": patentsId, "isValid": true};
    Response response = await dio.put(
      Urls.SET_PATENT_INIVATION,
      data: _param,
    );
    return response;
  }
}
