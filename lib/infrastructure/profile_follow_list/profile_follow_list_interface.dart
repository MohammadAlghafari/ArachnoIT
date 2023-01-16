import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/response/profile_follow_list_reponse.dart';
import 'package:flutter/material.dart';

abstract class ProfileFollowListInterface {
  Future<ResponseWrapper<ProfileFollowListResponse>> getProfileFollowListInfo({
    @required String healthcareProviderId,
  });
}
