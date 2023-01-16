import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteSkill {
  final Dio dio;
  DeleteSkill({@required this.dio});
  Future<dynamic> deleteSkill({
    String itemId,
  }) async {
    Map<String, dynamic> map = {"itemId": itemId};
    Response response = await dio.delete(Urls.DELETE_SKILL, data: map);
    return response;
  }
}
