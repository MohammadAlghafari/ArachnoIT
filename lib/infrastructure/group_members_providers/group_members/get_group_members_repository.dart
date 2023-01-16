import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';

import 'package:arachnoit/infrastructure/group_members_providers/group_members/caller/get_group_members_local_data_provider.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/response/get_group_members_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/response/remove_members_from_group_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'caller/get_group_members_remote_data_provider.dart';
import 'get_group_members_interface.dart';

class GetGroupMembersRepository implements GroupMembersInterface {
  final GetGroupMembersLocalDataProvider getGroupMembersLocalDataProvider;
  final GetGroupMembersRemoteDataProvider getGroupMembersRemoteDataProvider;

  GetGroupMembersRepository({@required this.getGroupMembersLocalDataProvider, @required this.getGroupMembersRemoteDataProvider});

  @override
  Future<ResponseWrapper<List<GetGroupMembersResponse>>> getGroupMember({
    @required String idGroup,
    @required bool includeHealthcareProvidersOnly,
    @required String query,
    @required bool enablePagination,
    @required int pageNumber,
    @required int pageSize,
    @required bool getNonGroupMembersOnly,
  }) async {
    try {
      Response response = await getGroupMembersRemoteDataProvider.getGroupMembers(
          idGroup: idGroup,
          includeHealthcareProvidersOnly: includeHealthcareProvidersOnly,
          enablePagination: enablePagination,
          getNonGroupMembersOnly: getNonGroupMembersOnly,
          pageNumber: pageNumber,
          pageSize: pageSize,
          query: query);
      return _prepareGroupMembersResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGroupMembersResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGroupMembersResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<bool>> removeMembersFromGroup({
    @required List<String> membersId,
    @required String groupId,
  }) async {
    try {
      Response response = await getGroupMembersRemoteDataProvider.removeMemberFromGroup(membersId: membersId, groupId: groupId);
      return _prepareRemoveMembersFromGroupsResponse(remoteResponse: response);
    } on DioError catch (e) {
      print('dioError');
      return _prepareRemoveMembersFromGroupsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      print('catch error');
      return _prepareRemoveMembersFromGroupsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<GetGroupMembersResponse>> _prepareGroupMembersResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GetGroupMembersResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List).map((x) => GetGroupMembersResponse.fromJson(x)).toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      print(remoteResponse.statusCode);
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

  ResponseWrapper<bool> _prepareRemoveMembersFromGroupsResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      res.data = remoteResponse.data[AppConst.ENTITY];
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage = remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName = remoteResponse.data[AppConst.OPERATON_NAME] as String;

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
