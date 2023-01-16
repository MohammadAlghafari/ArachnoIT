import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SearchProviderRemoteGetSpecification {
  Dio dio;
  SearchProviderRemoteGetSpecification({@required this.dio});
  Future<dynamic> getSpecification({
    @required accountTypeId,
  }) async {
    final params = {
      'accountTypeId': accountTypeId,
    };
    Response response =
        await dio.get(Urls.SPECIFICATION, queryParameters: params);
    return response;
  }
}
