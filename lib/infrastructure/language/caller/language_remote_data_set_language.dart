import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class LanguageRemoteDataSetLanguage {
  LanguageRemoteDataSetLanguage({@required this.dio});

  final Dio dio;

  Future<dynamic> setLanguage(
     ) async {
    Response response = await dio.put(Urls.SET_LANGUAGE,);
    return response;
  }
}
