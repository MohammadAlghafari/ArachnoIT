import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class RemoverLectures {
  final Dio dio;
  RemoverLectures({@required this.dio});
  Future<dynamic> removerLectures({
    String itemId,
  }) async {
    Map<String, dynamic> map = {"itemId": itemId};
    Response response = await dio.delete(Urls.DELETE_LECTURES, data: map);
    return response;
  }
}
