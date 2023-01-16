import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/blogs_vote_respose.dart';
import 'package:flutter/cupertino.dart';

abstract class BlogsEmphasisVoteInterface{
    Future<ResponseWrapper<List<BlogsVoteResponse>>> getEmphasesVotes({
    @required int pageNumber,
    @required int pageSize,
    @required String itemId,
    @required int voteType,
  });
}