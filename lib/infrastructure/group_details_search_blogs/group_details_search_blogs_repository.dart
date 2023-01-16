import 'package:arachnoit/infrastructure/group_details_search_blogs/caller/get_advanced_search_blogs_remote_data_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../home_blog/response/get_blogs_response.dart';
import 'caller/get_search_text_blogs_remote_data_provider.dart';
import 'group_details_search_blogs_interface.dart';

class GroupDetailsSearchBlogsRepository
    implements GroupDetailsSearchBlogsInterface {
  GroupDetailsSearchBlogsRepository(
      {this.getSearchTextBlogsRemoteDataProvider,
      this.getAdvancedSearchBlogsRemoteDataProvider});

  final GetSearchTextBlogsRemoteDataProvider
      getSearchTextBlogsRemoteDataProvider;
  final GetAdvancedSearchBlogsRemoteDataProvider
      getAdvancedSearchBlogsRemoteDataProvider;

  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getSearchTextBlogs(
      {String groupId, String query, int pageNumber, int pageSize}) async {
    try {
      Response response =
          await getSearchTextBlogsRemoteDataProvider.getSearchTextBlogs(
        groupId: groupId,
        query: query,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareBlogsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareBlogsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareBlogsResponse(
        remoteResponse: null,
      );
    }
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

  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getAdvancedSearchBlogs(
      {int accountTypeId,
      String categoryId,
      String subCategoryId,
      String groupId,
      List<String> tagsId,
      int pageNumber,
      int pageSize}) async {
    try {
      Response response =
          await getAdvancedSearchBlogsRemoteDataProvider.getAdvancedSearchBlogs(
        accountTypeId: accountTypeId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        groupId: groupId,
        tagsId: tagsId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareBlogsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareBlogsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareBlogsResponse(
        remoteResponse: null,
      );
    }
  }
}
