import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_advance_search_blogs.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_remote_blogs_add_tags.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_remote_blogs_main_category.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_remote_blogs_sub_category.dart';
import 'package:arachnoit/infrastructure/search_blogs/call/remote/get_text_search_blogs.dart';
import 'package:arachnoit/infrastructure/search_blogs/search_blogs_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class SearchBlogsRepository implements SearchBlogsInterface {
  GetRemoteBlogsMainCategory getRemoteBlogsMainCategory;
  GetRemoteBlogsSubCategory getRemoteBlogsSubCategory;
  GetBlogsAdvanceSearchAddTags getBlogsAdvanceSearchAddTags;
  GetAdvanceSearchBlogs getAdvanceSearchBlogs;
  GetTextSearchBlogs getTextSearchBlogs;
  SearchBlogsRepository({
    @required this.getRemoteBlogsMainCategory,
    @required this.getRemoteBlogsSubCategory,
    @required this.getBlogsAdvanceSearchAddTags,
    @required this.getAdvanceSearchBlogs,
    @required this.getTextSearchBlogs,
  });
  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getMainCategory() async {
    try {
      Response response = await getRemoteBlogsMainCategory.getCategories();
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
  Future<ResponseWrapper<List<SubCategoryResponse>>> getSubCategory(
      {categoryId}) async {
    try {
      Response response = await getRemoteBlogsSubCategory.getSubCategories(
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
      Response response = await getBlogsAdvanceSearchAddTags.getAllTags();
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

  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogsAdvanceSearch({
    String categoryId,
    String subCategoryId,
    int pageNumber,
    int pageSize,
    int accountTypeId,
    int orderByBlogs,
    List<String> tagsId,
    bool myFeed,
    String personId,
  }) async {
    try {
      Response response = await getAdvanceSearchBlogs.getBlogsAdvanceSearch(
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          pageNumber: pageNumber,
          pageSize: pageSize,
          accountTypeId: accountTypeId,
          orderByBlogs: orderByBlogs,
          tagsId: tagsId,
          myFeed: myFeed,
          personId: personId);
      return _prepareGetBlogsAdvanceSearch(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetBlogsAdvanceSearch(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<GetBlogsResponse>> _prepareGetBlogsAdvanceSearch(
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
  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogsTextSearch(
      {int pageNumber, int pageSize, String query}) async {
    try {
      Response response = await getTextSearchBlogs.getBlogsTextSearch(
          pageNumber: pageNumber, pageSize: pageSize, query: query);
      return _prepareGetBlogsTextSearch(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetBlogsTextSearch(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<GetBlogsResponse>> _prepareGetBlogsTextSearch(
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
}
