import 'package:arachnoit/infrastructure/discover_categories_sub_category_all_questions/caller/get_sub_category_all_questions_remote_Data_provider.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../api/response_type.dart' as ResType;

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';

import 'discover_categories_sub_category_all_questions_interface.dart';

class DiscoverCategoriesSubCategoryAllQuestionsRepository
    implements DiscoverCategoriesSubCategoryAllQuestionsInterface {
  DiscoverCategoriesSubCategoryAllQuestionsRepository(
      {this.getSubCategoryAllQuestionsRemoteDataProvider});

  final GetSubCategoryAllQuestionsRemoteDataProvider
      getSubCategoryAllQuestionsRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<QaaResponse>>> getSubCategoryAllQuestions(
      {String categoryId,
      String subCategoryId,
      int pageNumber,
      int pageSize}) async {
    try {
      Response response =
          await getSubCategoryAllQuestionsRemoteDataProvider.getAllQaas(
        subCategoryId: subCategoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareQaaResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareQaaResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareQaaResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<QaaResponse>> _prepareQaaResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<QaaResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => QaaResponse.fromMap(x))
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
