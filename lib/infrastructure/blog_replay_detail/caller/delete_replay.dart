import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteCommentReplay {
  final Dio dio;
  DeleteCommentReplay({@required this.dio});
  Future<dynamic> deleteSelectedReplay({String commentId}) async {
    final _param = {"itemId": commentId};
    Response response = await dio.delete(Urls.Remove_Replay, data: _param);
    return response;
  }
}
