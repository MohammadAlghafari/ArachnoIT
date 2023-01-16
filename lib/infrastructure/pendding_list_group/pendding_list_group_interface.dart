import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:flutter/cupertino.dart';

abstract class PenddingListGroupInterface {
  Future<ResponseWrapper<List<GroupResponse>>> getAllGroups({
    int pageNumber,
    int pageSize,
    String userId,
  });
  Future<ResponseWrapper<bool>> removeItemFromGroup({
    String userId,@required String groupId
  });
    Future<ResponseWrapper<bool>> acceptPendingGroupInvitation({
    String userId,@required String groupId
  });
}
