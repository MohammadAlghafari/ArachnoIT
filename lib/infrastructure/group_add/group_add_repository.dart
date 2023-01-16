





import 'dart:io';

import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'caller/group_add_remote_data_provider.dart';
import 'models/add_group_resposne.dart';
import 'models/group_category_response.dart';

class GroupAddRepository  {
  final GroupAddRemoteDataProvider groupAddRemoteDataProvider;

  GroupAddRepository({ @required this.groupAddRemoteDataProvider});

  @override
  Future<ResponseWrapper<List<CategoryAndSubResponse>>> getGroupCategory() async {
    try {
      Response response = await groupAddRemoteDataProvider.getCategoryGroup(
   );
      return _prepareGetGroupCategoryResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetGroupCategoryResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetGroupCategoryResponse(
        remoteResponse: null,
      );
    }
  }


  @override
  Future<ResponseWrapper<AddGroupResponse>> addGroup({
    @required String name,
    @required String id,
    @required String   description,
    @required   String parentGroupId,
    @required  List<String>  subCategory,
    @required   int privacyLevel,
    @required   File   file,
}) async {
    try {
      Response response = await groupAddRemoteDataProvider.addGroup(
        subCategory: subCategory,
        privacyLevel: privacyLevel,
        parentGroupId: parentGroupId,
        file: file,
        description: description,
        name: name,
        id: id
      );
      return _prepareAddGroupSResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareAddGroupSResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareAddGroupSResponse(
        remoteResponse: null,
      );
    }
  }


  @override
  Future<ResponseWrapper<List<GroupResponse>>> getAllGroups({
    @required String healthcareProviderId
}) async {
    try {
      Response response = await groupAddRemoteDataProvider.getAllGroup(healthcareProviderId: healthcareProviderId);
      return _prepareGetAllGroupSResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetAllGroupSResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetAllGroupSResponse(
        remoteResponse: null,
      );
    }
  }


  @override
  Future<ResponseWrapper<List<SubCategoryResponse>>> getGroupSubCategory({
  @required String categoryId
}) async {
    try {
      Response response = await groupAddRemoteDataProvider.getSubCategoryGroup(
      categoryId: categoryId
      );
      return _prepareGetGroupSubCategoryResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetGroupSubCategoryResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetGroupSubCategoryResponse(
        remoteResponse: null,
      );
    }
  }


  ResponseWrapper<List<CategoryAndSubResponse>> _prepareGetGroupCategoryResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CategoryAndSubResponse>>();
    if (remoteResponse != null) {

        res.data = (remoteResponse.data as List).map((x) => CategoryAndSubResponse.fromJson(x)).toList();

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

  ResponseWrapper<List<SubCategoryResponse>> _prepareGetGroupSubCategoryResponse({@required Response<dynamic> remoteResponse}) {
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

  ResponseWrapper<List<GroupResponse>> _prepareGetAllGroupSResponse({@required Response<dynamic> remoteResponse}) {
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


  ResponseWrapper<AddGroupResponse> _prepareAddGroupSResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<AddGroupResponse>();
    if (remoteResponse != null) {


      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:

          res.responseType = ResType.ResponseType.SUCCESS;
         res.data =  AddGroupResponse.fromJson(remoteResponse.data);
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
