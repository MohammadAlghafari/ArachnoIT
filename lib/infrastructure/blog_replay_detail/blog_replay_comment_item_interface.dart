import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:flutter/cupertino.dart';

abstract class BlogReplayDetailInterface {
  Future<ResponseWrapper<CommentBodyRespose>> setNewRaplay(
      {@required String comment, String postId});

  Future<ResponseWrapper<CommentBodyRespose>> updateSeletedReplay(
      {@required String comment, String postId, String commentId});

  Future<ResponseWrapper<bool>> deleteSelectedReplay(
      {@required String commentId});

  Future<ResponseWrapper<CommentResponse>> getCommentReplay({
    @required String commentId,
  });
    
    Future<ResponseWrapper<bool>> sendReport(
      {String commentId,String description});

}
