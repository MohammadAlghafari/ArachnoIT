import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetSubScriptionRemote {
  GetSubScriptionRemote({@required this.dio});
  final Dio dio;

  Future<dynamic> getSubCategories(List<dynamic> param) async {
    Response response = await dio.put(Urls.ACTION_SUBSCRIPTION, data: param);
    return response;
  }
}
