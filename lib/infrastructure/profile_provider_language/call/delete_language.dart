import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteLanguage {
  final Dio dio;
  DeleteLanguage({@required this.dio});
  Future<dynamic> deleteLanguage({
    String itemId,
  }) async {
    final _param = {
      "itemId": itemId,
    };
    Response response = await dio.delete(Urls.DELETE_LANGUAGE, data: _param);
    return response;
  }
}
