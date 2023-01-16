import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteLicenses {
  final Dio dio;
  DeleteLicenses({@required this.dio});
  Future<dynamic> deleteExperiance({
    String itemId,
  }) async {
    final _param = {"itemId": itemId};
    Response response = await dio.delete(Urls.DELETE_LICENSE, data: _param);
    return response;
  }
}
