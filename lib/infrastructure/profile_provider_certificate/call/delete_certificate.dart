import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteCertificate {
  final Dio dio;
  DeleteCertificate({@required this.dio});
  Future<dynamic> deleteCertificate({
    String itemId,
  }) async {
    final _param = {"itemId": itemId};
    Response response = await dio.delete(Urls.DELETE_CERTIFICATE, data: _param);
    return response;
  }
}
