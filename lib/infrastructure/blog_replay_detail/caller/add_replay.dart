import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AddReplay 
{
  final Dio dio;
  AddReplay({@required this.dio});
   Future<dynamic> addNewReplay({String message,String postId}) async {
    final _param = {
      "parentId": postId,
      "body": message,
      "isValid": true
    };
    Response response = await dio.post(Urls.ACTION_REPLAY, data: _param);
    return response;
  }
}