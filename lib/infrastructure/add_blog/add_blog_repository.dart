import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/add_blog/add_blog_interface.dart';
import 'package:arachnoit/infrastructure/add_blog/response/add_blog_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'caller/add_blog_remote_provider.dart';
import 'caller/get_blogs_main_category.dart';
import 'caller/get_blogs_sub_category.dart';
import 'caller/get_blogs_tags.dart';
import '../api/response_type.dart' as ResType;

class AddBlogRepository implements AddBlogInterface {
  AddBlogRepository({
    @required this.addBlogRemoteDataToServer,
    @required this.getBlogsMainCategory,
    @required this.getBlogsSubCategory,
    @required this.getBlogsTags,
  });

  final AddBlogRemoteDataToServer addBlogRemoteDataToServer;
  final GetBlogsMainCategory getBlogsMainCategory;
  final GetBlogsSubCategory getBlogsSubCategory;
  final GetBlogsTags getBlogsTags;

  @override
  Future<ResponseWrapper<AddBlogResponse>> addBlog({
    String id,
    String subCategoryId,
    String groupId,
    String title,
    String body,
    int blogType,
    bool viewToHealthcareProvidersOnly,
    bool publishByCreator,
    List<String> blogTags,
    List<FileResponse> files,
    String externalFileUrl,
    int externalFileType,
    List<String> removedFiles,
  }) async {
    try {
      Response response = await addBlogRemoteDataToServer.addBlog(
        id: id,
        subCategoryId: subCategoryId,
        groupId: groupId,
        title: title,
        body: body,
        blogType: blogType,
        viewToHealthcareProvidersOnly: viewToHealthcareProvidersOnly,
        publishByCreator: publishByCreator,
        blogTags: blogTags,
        files: files,
        externalFileUrl: externalFileUrl,
        externalFileType: externalFileType,
        removedFiles: removedFiles,
      );
      return _prepareAddBlogResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      print("ndlkasn;kldnsakldlasnlkasn ${e.error}");
      return _prepareAddBlogResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      print("ndlkasn;kldnsakldlasnlkasn $e");
      return _prepareAddBlogResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<AddBlogResponse> _prepareAddBlogResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<AddBlogResponse>();
    if (remoteResponse != null) {
      res.data = AddBlogResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
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
      Response response = await getBlogsTags.getAllTags();
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
      Response response = await getBlogsMainCategory.getCategories();
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
      Response response = await getBlogsSubCategory.getSubCategories(
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
