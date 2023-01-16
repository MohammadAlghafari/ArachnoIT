import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DeleteCourse {
  final Dio dio;
  DeleteCourse({@required this.dio});
  Future<dynamic> deleteCourse({
    String itemId,
  }) async {
    final _param = {"itemId": itemId};
    Response response = await dio.delete(Urls.Delete_Course, data: _param);
    return response;
  }
}
