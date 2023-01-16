import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_group_advance_search.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_group_search_text.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_remote_group_main_category.dart';
import 'package:arachnoit/infrastructure/search_group/call/remote/get_remote_group_sub_category.dart';
import 'package:arachnoit/infrastructure/search_group/search_group_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class SearchGroupRepositories implements SearchGroupInterface {
  GetRemoteGroupSubCategory getRemoteGroupSubCategory;
  GetRemoteGroupMainCategory getRemoteGroupMainCategory;
  GetGroupAdvanceSearch getGroupAdvanceSearch;
  GetGroupSearchText getGroupSearchText;
  SearchGroupRepositories(
      {@required this.getRemoteGroupMainCategory,
      @required this.getRemoteGroupSubCategory,
      @required this.getGroupAdvanceSearch,
      @required this.getGroupSearchText});
  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getMainCategory() async {
    try {
      Response response = await getRemoteGroupMainCategory.getCategories();
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

  @override
  Future<ResponseWrapper<List<SubCategoryResponse>>> getSubCategory(
      {categoryId}) async {
    try {
      Response response = await getRemoteGroupSubCategory.getSubCategories(
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
  Future<ResponseWrapper<List<GroupResponse>>> getAdvanceSearchGroups(
      {int pageNumber,
      int pageSize,
      String searchText,
      String categoryId,
      String subCategoryID,
      String userId,
      }) async {
    try {
      Response response = await getGroupAdvanceSearch.getAdvanceSearchGroups(
          categoryId: categoryId,
          pageNumber: pageNumber,
          pageSize: pageSize,
          searchText: searchText,
          subCategoryID: subCategoryID,
          userId: userId
          );
      return _prepareAdvanceSearchResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareAdvanceSearchResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<GroupResponse>> _prepareAdvanceSearchResponse(
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

  @override
  Future<ResponseWrapper<List<GroupResponse>>> getGroupsSearchText(
      {int pageNumber,
      int pageSize,
      String searchText,
      String categoryId,
      String subCategoryID,
      String userId,
      }) async {
    try {
      Response response = await getGroupSearchText.getGroupsSearchText(
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchText: searchText,
        userID: userId
      );
      return _prepareGetGroupsSearchText(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetGroupsSearchText(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<GroupResponse>> _prepareGetGroupsSearchText(
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
