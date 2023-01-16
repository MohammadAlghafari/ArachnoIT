import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetQuestionDetailsRemoteDataProvider {
  GetQuestionDetailsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getQuestionDetails({
    @required String questionId,
  }) async {
    final params = {
      'questionId': questionId ,
    };
    Response response = await dio.get(Urls.GET_QUESTION_DETAILS, queryParameters: params);
    return response;
  }


  Future<dynamic> removeAnswer({
    @required String answerId,
  }) async {
    final params = {
      'itemId': answerId ,
    };
    Response response = await dio.delete(Urls.REMOVE_ANSWER, data: params);
    return response;
  }


  Future<dynamic> sendReportAnswer({
    @required String description,
    @required  String commentId
  }) async {
    final _param = {
      "itemId": commentId,
      "reportDescription": description,
      "reportPlatformType": 4,
      "id": "00000000-0000-0000-0000-000000000000",
      "isValid": true
    };
    Response response = await dio.post(Urls.ADD_REPORT, data: _param);
    return response;
  }
}
