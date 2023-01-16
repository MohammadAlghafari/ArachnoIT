import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:arachnoit/infrastructure/search_question/caller/remote/get_advance_search_questions.dart';
import 'package:arachnoit/infrastructure/search_question/caller/remote/get_remote_questions_add_tags.dart';
import 'package:arachnoit/infrastructure/search_question/caller/remote/get_remote_questions_main_category.dart';
import 'package:arachnoit/infrastructure/search_question/caller/remote/get_remote_questions_sub_category.dart';
import 'package:arachnoit/infrastructure/search_question/caller/remote/get_text_search_questions.dart';
import 'package:arachnoit/infrastructure/search_question/search_question_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class SearchQuestionsRepository implements SearchQuestionsInterface {
  GetRemoteQuestionsMainCategory getRemoteQuestionsMainCategory;
  GetRemoteQuestionsSubCategory getRemoteQuestionsSubCategory;
  GetQuestionsAdvanceSearchAddTags getQuestionsAdvanceSearchAddTags;
  GetAdvanceSearchQuestions getAdvanceSearchQuestions;
  GetTextSearchQuestions getTextSearchQuestions;
  SearchQuestionsRepository({
    @required this.getRemoteQuestionsMainCategory,
    @required this.getRemoteQuestionsSubCategory,
    @required this.getQuestionsAdvanceSearchAddTags,
    @required this.getAdvanceSearchQuestions,
    @required this.getTextSearchQuestions,
  });
  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getMainCategory() async {
    try {
      Response response = await getRemoteQuestionsMainCategory.getCategories();
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
      Response response = await getRemoteQuestionsSubCategory.getSubCategories(
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
      Response response = await getQuestionsAdvanceSearchAddTags.getAllTags();
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
  Future<ResponseWrapper<List<QaaResponse>>> getQuestionsAdvanceSearch({
    String categoryId,
    String subCategoryId,
    int pageNumber,
    int pageSize,
    int accountTypeId,
    int orderByQuestions,
    List<String> tagsId,
    String personId,
  }) async {
    try {
      Response response = await getAdvanceSearchQuestions.getQuestionsAdvanceSearch(
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          pageNumber: pageNumber,
          pageSize: pageSize,
          accountTypeId: accountTypeId,
          orderByQuestions: orderByQuestions,
          tagsId: tagsId,
          personId: personId);
      return _prepareGetBlogsAdvanceSearch(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetBlogsAdvanceSearch(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<QaaResponse>> _prepareGetBlogsAdvanceSearch(
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
  Future<ResponseWrapper<List<QaaResponse>>> getQuestionsTextSearch(
      {int pageNumber, int pageSize, String query}) async {
    try {
      Response response = await getTextSearchQuestions.getBlogsTextSearch(
          pageNumber: pageNumber, pageSize: pageSize, query: query);
      return _prepareGetBlogsTextSearch(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetBlogsTextSearch(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<QaaResponse>> _prepareGetBlogsTextSearch(
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
