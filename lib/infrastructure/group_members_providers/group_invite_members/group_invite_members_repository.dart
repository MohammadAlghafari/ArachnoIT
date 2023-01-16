import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;
import 'caller/group_invite_members_local_data_provider.dart';
import 'caller/group_invite_members_remote_data_provider.dart';
import 'get_group_invite_members_interface.dart';
import 'response/Invite_member_to_group_response.dart';
import 'response/group_invite_members_response.dart';
import 'response/invite_member_json_body_request.dart';

class GetGroupInviteMembersRepository implements GroupInviteMembersInterface {
  final GetGroupInviteMembersLocalDataProvider getGroupInviteMembersLocalDataProvider;
  final GetGroupInviteMembersRemoteDataProvider getGroupInviteMembersRemoteDataProvider;

  GetGroupInviteMembersRepository({@required this.getGroupInviteMembersLocalDataProvider, @required this.getGroupInviteMembersRemoteDataProvider});

  @override
  Future<ResponseWrapper<List<GetGroupInviteMembersResponse>>> getGroupInviteMember({
    @required String idGroup,
    @required bool includeHealthcareProvidersOnly,
    @required String query,
    @required bool enablePagination,
    @required int pageNumber,
    @required int pageSize,
    @required bool getNonGroupMembersOnly,
  }) async {
    try {
      Response response = await getGroupInviteMembersRemoteDataProvider.getGroupInviteMembers(
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

  Future<ResponseWrapper<InviteMemberToGroupResponse>> inviteMemberToGroup(
      {    @required List<dynamic> inviteMemberPermission,
        @required String groupId,
        @required String personId,}) async {
    try {
      Response response = await getGroupInviteMembersRemoteDataProvider.inviteMemberToGroup(
groupId: groupId,
        personId: personId,
        inviteMemberPermission: inviteMemberPermission
      );

      return _prepareInviteMembersResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareInviteMembersResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareInviteMembersResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<GetGroupInviteMembersResponse>> _prepareGroupMembersResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GetGroupInviteMembersResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List).map((x) => GetGroupInviteMembersResponse.fromJson(x)).toList();
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

  ResponseWrapper<InviteMemberToGroupResponse> _prepareInviteMembersResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<InviteMemberToGroupResponse>();
    if (remoteResponse != null) {
      //  res.data = (remoteResponse.data as List).map((x) => GetGroupInviteMembersResponse.fromJson(x)).toList();
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
