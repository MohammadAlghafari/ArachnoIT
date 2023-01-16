import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UpdatComment {
  final Dio dio;
  UpdatComment({@required this.dio});
  Future<dynamic> updateSelectedComment({String message,String postId,String commentId}) async {
    final _param = {
      "parentId": postId,
      "body": message,
      "isValid": true,
      "id": commentId,
    };
    Response response = await dio.post(Urls.ACTION_COMMENT, data: _param);
    return response;
  }
}
// I/flutter (30714): ║ {parentId: 3e7efda7-c632-4a2f-a63d-7fddd3d61779, body: 90909, isValid: true, id: 4ac7a051-
// I/flutter (30714): ║ 4337-40ef-938c-4005898ee980}
