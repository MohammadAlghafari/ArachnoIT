import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SearchRemoteProviderGetAccount {
  final Dio dio;
  SearchRemoteProviderGetAccount({@required this.dio});
  Future<dynamic> getAccountTypes() async {
    Response response = await dio.get(Urls.ACCOUNT_TYPES);
    return response;
  }
}
