import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/group_details_search/caller/get_group_advance_search_add_tags.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import '../common_response/sub_category_response.dart';
import 'caller/get_group_advanced_search_categories_remote_data_provider.dart';
import 'caller/get_group_advanced_search_sub_categories_remote_data_provider.dart';
import 'group_details_search_interface.dart';

class GroupDetailsSearchRepository implements GroupDetailsSearchInterface {
  GroupDetailsSearchRepository({
    @required this.getGroupsAdvancedSearchCategoriesRemoteDataProvider,
    @required this.getGroupsAdvancedSearchSubCategoriesRemoteDataProvider,
    @required this.getGroupAdvanceSearchAddTags,
  });
  final GetGroupsAdvancedSearchCategoriesRemoteDataProvider
      getGroupsAdvancedSearchCategoriesRemoteDataProvider;
  final GetGroupsAdvancedSearchSubCategoriesRemoteDataProvider
      getGroupsAdvancedSearchSubCategoriesRemoteDataProvider;
  final GetGroupAdvanceSearchAddTags getGroupAdvanceSearchAddTags;
  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories() async {
    try {
      Response response =
          await getGroupsAdvancedSearchCategoriesRemoteDataProvider
              .getCategories();
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

  @override
  Future<ResponseWrapper<List<SubCategoryResponse>>> getSubCategories(
      {categoryId}) async {
    try {
      Response response =
          await getGroupsAdvancedSearchSubCategoriesRemoteDataProvider
              .getSubCategories(
        categoryId: categoryId,
      );
      return _prepareSubCategoriesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSubCategoriesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<SubCategoryResponse>> _prepareSubCategoriesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<SubCategoryResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => SubCategoryResponse.fromMap(x))
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
  Future<ResponseWrapper<List<TagResponse>>> getAddTags() async {
    try {
      Response response = await getGroupAdvanceSearchAddTags.getAllTags();
      return _prepareAddTagsCategoriesResponse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddTagsCategoriesResponse(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<TagResponse>> _prepareAddTagsCategoriesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<TagResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => TagResponse.fromMap(x))
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
