import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:flutter/cupertino.dart';

abstract class BlogsVoteItemInterface {

  Future<ResponseWrapper<BriefProfileResponse>> getBriefProfile(
      {@required String id});
}