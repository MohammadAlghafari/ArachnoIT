import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import 'caller/get_categories_remote_data_provider.dart';
import 'discover_categories_interface.dart';

class DiscoverCategoriesRepository implements DiscoverCategoriesInterface {
  DiscoverCategoriesRepository({this.getCategoriesRemoteDataProvider});

  final GetCategoriesRemoteDataProvider getCategoriesRemoteDataProvider;

  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories() async {
    try {
      Response response = await getCategoriesRemoteDataProvider.getCategories();
      return _prepareCategoriesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCategoriesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<CategoryResponse>> _prepareCategoriesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CategoryResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => CategoryResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
