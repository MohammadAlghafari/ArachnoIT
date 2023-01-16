import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:flutter/material.dart';

import 'response/get_group_members_response.dart';
import 'response/remove_members_from_group_response.dart';

abstract class GroupMembersInterface{
  Future<ResponseWrapper<List<GetGroupMembersResponse>>> getGroupMember({
    @required String idGroup,
    @required bool includeHealthcareProvidersOnly,
    @required String query,
    @required bool enablePagination,
    @required int pageNumber,
    @required int pageSize,
    @required bool getNonGroupMembersOnly,
});
  Future<ResponseWrapper<bool>> removeMembersFromGroup({
    @required List<String> membersId,
    @required String groupId,
});


}