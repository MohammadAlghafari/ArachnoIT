import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/group_response.dart';
import '../home_blog/response/get_blogs_response.dart';
import '../home_qaa/response/qaa_response.dart';
import 'caller/get_sub_category_blogs_remote_data_provider.dart';
import 'caller/get_sub_category_groups_remote_Data_provider.dart';
import 'caller/get_sub_category_questions_remote_data_provider.dart';
import 'discover_categories_details_interface.dart';

class DiscoverCategoriesDetailsRepository
    implements DiscoverCategoriesDetailsInterface {
  DiscoverCategoriesDetailsRepository(
      {@required this.getSubCategoryBlogsRemoteDataProvider,
      @required this.getSubCategoryGroupsRemoteDataProvider,
      @required this.getSubCategoryQuestionsRemoteDataProvider});
  final GetSubCategoryBlogsRemoteDataProvider
      getSubCategoryBlogsRemoteDataProvider;
  final GetSubCategoryGroupsRemoteDataProvider
      getSubCategoryGroupsRemoteDataProvider;
  final GetSubCategoryQuestionsRemoteDataProvider
      getSubCategoryQuestionsRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoryBlogs(
      {String categoryId,
      String subCategoryId,
      int pageNumber,
      int pageSize}) async {
    try {
      Response response =
          await getSubCategoryBlogsRemoteDataProvider.getSubCategoryBlogs(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareBlogsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareBlogsResponse(remoteResponse:null);
    } catch (e) {
      return _prepareBlogsResponse(remoteResponse:null);
    }
  }

  @override
  Future<ResponseWrapper<List<GroupResponse>>> getSubCategoryGroups(
      {int pageNumber,
      int pageSize,
      bool enablePagination,
      String searchString,
      String healthcareProviderId,
      bool approvalListOnly,
      int ownershipType,
      String categoryId,
      String subCategoryId,
      bool mySubscriptionsOnly}) async {
    try {
      Response response =
          await getSubCategoryGroupsRemoteDataProvider.getSubCategoryGroups(
        pageNumber: pageNumber,
        pageSize: pageSize,
        enablePagination: enablePagination,
        searchString: searchString,
        healthcareProviderId: healthcareProviderId,
        approvalListOnly: approvalListOnly,
        ownershipType: ownershipType,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        mySubscriptionsOnly: mySubscriptionsOnly,
      );
      return _prepareGroupsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGroupsResponse(remoteResponse:null);
    } catch (e) {
      return _prepareGroupsResponse(remoteResponse:null);
    }
  }

  @override
  Future<ResponseWrapper<List<QaaResponse>>> getSubCategoryQuestions(
      {String categoryId,
      String subCategoryId,
      int pageNumber,
      int pageSize}) async {
    try {
      Response response =
          await getSubCategoryQuestionsRemoteDataProvider.getQaas(
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareQaaResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareQaaResponse(remoteResponse:null);
    } catch (e) {
      return _prepareQaaResponse(remoteResponse:null);
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

  ResponseWrapper<List<GetBlogsResponse>> _prepareBlogsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GetBlogsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => GetBlogsResponse.fromMap(x))
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

  ResponseWrapper<List<GroupResponse>> _prepareGroupsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GroupResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => GroupResponse.fromMap(x))
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
