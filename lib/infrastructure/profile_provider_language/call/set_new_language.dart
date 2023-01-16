import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetNewLanguage {
  final Dio dio;
  SetNewLanguage({@required this.dio});
  Future<dynamic> addNewLanguage({
    int languageLevel,
    String languageId,
  }) async {
    final _param = {
      "isValid": true,
      "id": languageId,
      "languageLevel": languageLevel,
    };
    Response response = await dio.post(Urls.SET_LANGUAGE_SKILL, data: _param);
    return response;
  }
}
