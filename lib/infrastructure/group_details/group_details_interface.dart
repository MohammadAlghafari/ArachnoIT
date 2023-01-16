import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/group_details/response/delete_group_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_details_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/joined_group_response.dart';
import 'package:flutter/material.dart';

abstract class GroupDetailsInterface {
  Future<ResponseWrapper<GroupDetailsResponse>> getGroupDetails({
    @required String groupId,
  });
  Future<ResponseWrapper<JoinedGroupResponse>> joinISelectedGroup({
    @required String groupId,
  });


  Future<ResponseWrapper<DeleteGroupResponse>> deleteGroup({
    @required String groupId,
  });
}
