import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/invite_member_json_body_request.dart';

import 'response/Invite_member_to_group_response.dart';
import 'response/group_invite_members_response.dart';



abstract class GroupInviteMembersInterface{
  Future<ResponseWrapper<List<GetGroupInviteMembersResponse>>> getGroupInviteMember();
  Future<ResponseWrapper<InviteMemberToGroupResponse>> inviteMemberToGroup();
}