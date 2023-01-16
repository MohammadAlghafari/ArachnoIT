import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteComment {
  final Dio dio;
  DeleteComment({@required this.dio});
  Future<dynamic> deleteComment({String commentId}) async {
    final _param = {"itemId": commentId};
    Response response = await dio.delete(Urls.REMOVE_COMMENT, data: _param);
    return response;
  }
}
