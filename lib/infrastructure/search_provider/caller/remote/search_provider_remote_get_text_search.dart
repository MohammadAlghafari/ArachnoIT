import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SearchProviderRemoteGetTextSearch{
  final Dio dio;
  SearchProviderRemoteGetTextSearch({this.dio});
    Future<dynamic> getSearchTextProvider({
    @required searchText,
    @required pageNumber,
    @required pageSize,
  }
      ) async {
         final params = {
      'searchText': searchText,
      'pageNumber':pageNumber,
      'pageSize':pageSize
    };
    Response response = await dio.get(Urls.TEXT_SEARCH_PROVIDER, queryParameters: params);
    return response;
  }
}