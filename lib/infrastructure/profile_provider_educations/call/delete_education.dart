import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteEducation {
  final Dio dio;
  DeleteEducation({@required this.dio});
  Future<dynamic> deleteEducation({
    String itemId,
  }) async {
    print("The items id is $itemId");
    final _param = {"itemId": itemId};
    Response response = await dio.delete(Urls.DELETE_EDUCATION, data: _param);
    return response;
  }
}
