import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/blogs_vote_respose.dart';
import 'package:flutter/cupertino.dart';

abstract class BlogsUsefulVoteInterface {
  Future<ResponseWrapper<List<BlogsVoteResponse>>> getPostsVotes({
    @required int pageNumber,
    @required int pageSize,
    @required String itemId,
    @required int itemType,
    @required int voteType,
  });
}
