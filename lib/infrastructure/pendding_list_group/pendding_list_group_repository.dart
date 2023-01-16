import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/pendding_list_group/caller/accept_group_invitation.dart';
import 'package:arachnoit/infrastructure/pendding_list_group/caller/get_all_groups.dart';
import 'package:arachnoit/infrastructure/pendding_list_group/caller/remove_group.dart';
import 'package:arachnoit/infrastructure/pendding_list_group/pendding_list_group_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class PenddingListGroupRepository implements PenddingListGroupInterface {
  final GetAllPenddingGroups getAllPenddingGroups;
  final RemoveFromGroup removeFromGroup;
  final AcceptGroupInvitation acceptGroupInvitation;
  PenddingListGroupRepository(
      {@required this.getAllPenddingGroups,
      @required this.removeFromGroup,
      @required this.acceptGroupInvitation});
  @override
  Future<ResponseWrapper<List<GroupResponse>>> getAllGroups(
      {int pageNumber, int pageSize, String userId}) async {
    try {
      Response response = await getAllPenddingGroups.getAdvanceSearchGroups(
          pageNumber: pageNumber, pageSize: pageSize, userId: userId);
      return _prepareAdvanceSearchResponse(remoteResponse: response);
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
  Future<ResponseWrapper<bool>> removeItemFromGroup(
      {String userId, @required String groupId}) async {
    try {
      Response response = await removeFromGroup.removeMemberFromGroup(
          userId: userId, groupId: groupId);
      return _prepareRemoveItemFromGroup(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareRemoveItemFromGroup(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<bool> _prepareRemoveItemFromGroup(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage = remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =remoteResponse.data[AppConst.OPERATON_NAME] as String;
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
  Future<ResponseWrapper<bool>> acceptPendingGroupInvitation(
      {String userId, String groupId}) async {
    try {
      Response response = await acceptGroupInvitation.acceptGroupInvitation(
          userId: userId, groupId: groupId);
      return _prepareAcceptPendingGroupInvitation(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAcceptPendingGroupInvitation(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<bool> _prepareAcceptPendingGroupInvitation(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
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
}
