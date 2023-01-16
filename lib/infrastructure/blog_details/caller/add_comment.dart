import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AddComment {
  final Dio dio;
  AddComment({@required this.dio});
  Future<dynamic> addNewComment({String message,String postId}) async {
    final _param = {
      "parentId": postId,
      "body": message,
      "isValid": true
    };
    Response response = await dio.post(Urls.ACTION_COMMENT, data: _param);
    return response;
  }
}
