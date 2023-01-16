import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/common_response/vote_response.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import 'response/blog_details_response.dart';

abstract class BlogDetailsInterface {
  Future<ResponseWrapper<BlogDetailsResponse>> getBlogDetails({
    @required String blogId,
  });

  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForBlogDetails({
    @required String itemId,
    @required bool status,
  });

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForBlogDetails({
    @required String itemId,
    @required bool status,
  });
  Future<ResponseWrapper<CommentBodyRespose>> setNewComment({@required String comment, String postId});

  Future<ResponseWrapper<CommentBodyRespose>> updateComment({@required String comment, String postId, String commentId});

  Future<ResponseWrapper<bool>> deleteSelectedComment({@required String commentId});

  Future<ResponseWrapper<bool>> sendReport(
      {String commentId,String description});
}
