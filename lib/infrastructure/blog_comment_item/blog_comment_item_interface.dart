import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/vote_response.dart';

abstract class BlogCommentItemInterface {
 

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForComment({
    @required String itemId,
    @required bool status,
  });
  

  
  Future<ResponseWrapper<BriefProfileResponse>> getBriefProfile(
      {@required String id});
}
