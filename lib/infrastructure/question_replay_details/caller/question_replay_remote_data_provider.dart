import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class QuestionReplayRemoteDataProvider {
  final Dio dio;
  const QuestionReplayRemoteDataProvider({@required this.dio});

  Future<dynamic> questionAddNewReplay({String message,String postId}) async {
    final _param = {
      "answerId": postId,
      "body": message,
      "isValid": true
    };
    Response response = await dio.post(Urls.Question_ACTION_COMMENT, data: _param);
    return response;
  }

  Future<dynamic> questionDeleteSelectedReplay({String commentId}) async {
    final _param = {
      "itemId": commentId
    };
    Response response = await dio.delete(Urls.Question_REMOVE_COMMENT, data: _param);
    return response;
  }
  Future<dynamic> questionGetCommentReplay({
    @required String answerId,
    @required String questionId,

  }) async {
    final params = {
      'questionId':questionId,
      'answerId': answerId
    };
    Response response = await dio.get(Urls.Question_GET_COMMENT_INFO, queryParameters: params);
    return response;
  }

  Future<dynamic> sendReport({String commentId, String description}) async {
    final _param = {
      "itemId": commentId,
      "reportDescription": description,
      "reportPlatformType": 7,
      "id": "00000000-0000-0000-0000-000000000000",
      "isValid": true
    };
    Response response = await dio.post(Urls.ADD_REPORT, data: _param);
    return response;
  }



  Future<dynamic> updateSelectedReplay({
    String message,
    String answerId,
    String replayCommentId
  }) async {
    final _param = {
      "answerId": answerId,
      "body": message,
      "isValid": true,
      "id": replayCommentId,
    };
    Response response = await dio.post(Urls.Question_ACTION_COMMENT, data: _param);
    return response;
  }

}