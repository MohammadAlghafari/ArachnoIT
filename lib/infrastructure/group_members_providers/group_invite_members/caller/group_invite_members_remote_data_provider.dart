import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/invite_member_json_body_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetGroupInviteMembersRemoteDataProvider {
  const GetGroupInviteMembersRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getGroupInviteMembers({
    @required String idGroup,
    @required bool includeHealthcareProvidersOnly,
    @required String query,
    @required bool enablePagination,
    @required int pageNumber,
    @required int pageSize,
    @required bool getNonGroupMembersOnly,
  }) async {
    final params = {
      'itemId': idGroup ?? "",
      'includeHealthcareProvidersOnly': includeHealthcareProvidersOnly ?? false,
      'query': query ?? "",
      'enablePagination': enablePagination ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? 20,
      'GetNonGroupMembersOnly': getNonGroupMembersOnly ?? true,
    };

    Response response = await dio.get(Urls.Get_Group_Members, queryParameters: params);
    return response;
  }

  Future<dynamic> inviteMemberToGroup({
    @required List<dynamic> inviteMemberPermission,
    @required String groupId,
    @required String personId,

  }) async {

    final param=
      {
        "groupPermissions": inviteMemberPermission,
        "personId": personId,
        "encodedName": "string",
        "requestStatus": 0,
        "id": groupId,
        "isValid": true
      };
    Response response = await dio.put(Urls.Invite_Member_To_Group, data: param);
    return response;







  }
}
