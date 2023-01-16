import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/add_questions/add_question_interface.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/add_question_remote_provider.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/get_questions_main_category.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/get_questions_sub_category.dart';
import 'package:arachnoit/infrastructure/add_questions/caller/get_questions_tags.dart';
import 'package:arachnoit/infrastructure/add_questions/response/add_question_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../api/response_type.dart' as ResType;

class AddQuestionRepository implements AddQuestionInterface {
  AddQuestionRepository({
    @required this.addQuestionRemoteDataToServer,
    @required this.getQuestionsMainCategory,
    @required this.getQuestionsSubCategory,
    @required this.getQuestionsTags,
  });

  final AddQuestionRemoteDataToServer addQuestionRemoteDataToServer;
  final GetQuestionsMainCategory getQuestionsMainCategory;
  final GetQuestionsSubCategory getQuestionsSubCategory;
  final GetQuestionsTags getQuestionsTags;

  @override
  Future<ResponseWrapper<AddQuestionResponse>> addQuestion({
    String id,
    List<String> subCategoryIds,
    String groupId,
    String title,
    String body,
    bool viewToHealthcareProvidersOnly,
    bool askAnonymously,
    List<String> questionTags,
    List<FileResponse> files,
    List<String> removedFiles,
  }) async {
    try {
      Response response = await addQuestionRemoteDataToServer.addQuestion(
          id: id,
          subCategoryIds: subCategoryIds,
          groupId: groupId,
          title: title,
          body: body,
          viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
          askAnonymously: askAnonymously,
          questionTags: questionTags,
          files: files,
          removedFiles: removedFiles,);
      return _prepareAddQuestionResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareAddQuestionResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareAddQuestionResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<AddQuestionResponse> _prepareAddQuestionResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<AddQuestionResponse>();
    if (remoteResponse != null) {
      res.data =
          AddQuestionResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
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
  Future getAllTags() async {
    try {
      Response response = await getQuestionsTags.getAllTags();
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
  Future getCategories() async {
    try {
      Response response = await getQuestionsMainCategory.getCategories();
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
  Future getSubCategories({String categoryId}) async {
    try {
      Response response = await getQuestionsSubCategory.getSubCategories(
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
}
