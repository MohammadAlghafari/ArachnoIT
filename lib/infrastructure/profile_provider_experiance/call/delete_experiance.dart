import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteExperiance {
  final Dio dio;
  DeleteExperiance({@required this.dio});
  Future<dynamic> deleteExperiance({
    String itemId,
  }) async {
    final _param = {"itemId": itemId};
    Response response = await dio.delete(Urls.DELETE_EXPERIANCE, data: _param);
    return response;
  }
}
