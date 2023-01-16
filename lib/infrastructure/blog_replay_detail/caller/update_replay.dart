import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UpdateCommentReplay {
  final Dio dio;
  UpdateCommentReplay({@required this.dio});
  Future<dynamic> updateSelectedReplay({String message, String postId, String commentId}) async {
    final _param = {
      "parentId": postId,
      "body": message,
      "isValid": true,
      "id": commentId,
    };
    Response response = await dio.post(Urls.ACTION_REPLAY, data: _param);
    return response;
  }
}
