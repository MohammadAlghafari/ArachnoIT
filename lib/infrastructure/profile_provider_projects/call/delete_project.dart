import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteProject {
  final Dio dio;
  DeleteProject({@required this.dio});
  Future<dynamic> deleteProject({
    String itemId,
  }) async {
    Map<String, dynamic> map = {"itemId": itemId};
    Response response = await dio.delete(Urls.DELETE_PROJECT, data: map);
    return response;
  }
}
