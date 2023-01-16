import 'package:arachnoit/infrastructure/group_details_search_questions/caller/get_advanced_search_questions_remote_data_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../home_qaa/response/qaa_response.dart';
import 'caller/get_search_text_questions_remote_data_provider.dart';
import 'group_details_search_questions_interface.dart';

class GroupDetailsSearchQuestionsRepository
    implements GroupDetailsSearchQuestionsInterface {
  GroupDetailsSearchQuestionsRepository(
      {this.getSearchTextQuestionsRemoteDataProvider,
      this.getAdvancedSearchQuestionsRemoteDataProvider});

  final GetSearchTextQuestionsRemoteDataProvider
      getSearchTextQuestionsRemoteDataProvider;
  final GetAdvancedSearchQuestionsRemoteDataProvider
      getAdvancedSearchQuestionsRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<QaaResponse>>> getSearchTextQuestions(
      {String groupId, String query, int pageNumber, int pageSize}) async {
    try {
      Response response =
          await getSearchTextQuestionsRemoteDataProvider.getSearchTextQuestions(
        groupId: groupId,
        query: query,
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

  @override
  Future<ResponseWrapper<List<QaaResponse>>> getAdvancedSearchQuestions(
      {int accountTypeId,
      String categoryId,
      String subCategoryId,
      String groupId,
      List<String> tagsId,
      int pageNumber,
      int pageSize}) async {
    try {
      Response response = await getAdvancedSearchQuestionsRemoteDataProvider
          .getAdvancedSearchQuestions(
        accountTypeId: accountTypeId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        groupId: groupId,
        tagsId: tagsId,
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
}
