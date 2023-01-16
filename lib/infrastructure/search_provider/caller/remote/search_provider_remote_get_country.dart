import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api/urls.dart';

class SearchProviderRemoteGetCountry {
  SearchProviderRemoteGetCountry({@required this.dio});
  final Dio dio;

  Future<dynamic> getCountries() async {
    Response response = await dio.get(
      Urls.COUNTRIES,
    );
    return response;
  }
}
