import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/group_details/caller/get_group_details_remote_Data_provider.dart';
import 'package:arachnoit/infrastructure/group_details/caller/join_to_group.dart';
import 'package:arachnoit/infrastructure/group_details/group_details_interface.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_details_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/joined_group_response.dart';
import 'package:flutter/material.dart';
import '../api/response_type.dart' as ResType;
import 'package:dio/dio.dart';

import 'response/delete_group_response.dart';

class GroupDetailsRepository implements GroupDetailsInterface {
  final JoinInGroup joinInGroup;
  final GetGroupDetailsRemoteDataProvider getGroupDetailsRemoteDataProvider;



  @override
  Future<ResponseWrapper<DeleteGroupResponse>> deleteGroup(
      {String groupId}) async {
    try {
      Response response = await getGroupDetailsRemoteDataProvider.deleteGroup(
        groupId: groupId,
      );
      return _prepareDeleteGroupResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareDeleteGroupResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareDeleteGroupResponse(
        remoteResponse: null,
      );
    }
  }




  GroupDetailsRepository({
    @required this.getGroupDetailsRemoteDataProvider,
    @required this.joinInGroup,
  });
  @override
  Future<ResponseWrapper<GroupDetailsResponse>> getGroupDetails(
      {String groupId}) async {
    try {
      Response response =
          await getGroupDetailsRemoteDataProvider.getGroupDetails(
        groupId: groupId,
      );
      return _prepareGroupDetailsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      print("the error is $e");
      return _prepareGroupDetailsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      print("the error is $e");
      return _prepareGroupDetailsResponse(
        remoteResponse: null,
      );
    }
  }



  ResponseWrapper<DeleteGroupResponse> _prepareDeleteGroupResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<DeleteGroupResponse>();
    if (remoteResponse != null) {
      res.data = DeleteGroupResponse.fromJson(remoteResponse.data);
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



  ResponseWrapper<GroupDetailsResponse> _prepareGroupDetailsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<GroupDetailsResponse>();
    if (remoteResponse != null) {
      res.data = GroupDetailsResponse.fromMap(remoteResponse.data);
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
  Future<ResponseWrapper<JoinedGroupResponse>> joinISelectedGroup(
      {String groupId}) async {
    try {
      Response response = await joinInGroup.joinInSelectedGroup(
        groupId: groupId,
      );
      return _preparejoinISelectedGroup(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _preparejoinISelectedGroup(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _preparejoinISelectedGroup(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<JoinedGroupResponse> _preparejoinISelectedGroup(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<JoinedGroupResponse>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200)
        res.data = JoinedGroupResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
      else
        res.data = null;
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
      res.errorMessage = "Error happened try again";
    }
    return res;
  }
}
