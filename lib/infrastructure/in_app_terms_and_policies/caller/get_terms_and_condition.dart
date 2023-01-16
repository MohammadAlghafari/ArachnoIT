import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetTermsAndConditions {
  final Dio dio;

  GetTermsAndConditions({
    @required this.dio,
  });

  Future<dynamic> getTermsAndConditionsInfo({
    int termsOrPolicy,
  }) async {
    final _param = {
      'type': termsOrPolicy,
    };

    Response response = await dio.get(
      Urls.GET_TERMS_AND_CONDITION,
      queryParameters: _param,
    );
    return response;
  }
}
