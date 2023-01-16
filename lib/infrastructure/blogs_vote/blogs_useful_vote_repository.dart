import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/blogs_vote/call/get_useful_votes.dart';
import 'package:arachnoit/infrastructure/common_response/blogs_vote_respose.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'blogs_useful_vote_Interface.dart';
import '../api/response_type.dart' as ResType;

class PostsVotesRepository extends BlogsUsefulVoteInterface {
  GetVotes getVotes;
  PostsVotesRepository({@required this.getVotes});

  @override
  Future<ResponseWrapper<List<BlogsVoteResponse>>> getPostsVotes({
    int pageNumber,
    int pageSize,
    String itemId,
    int itemType,
    int voteType,
  }) async {
    try {
      Response response = await getVotes.getBlogsUsefulVotes(
          pageNumber: pageNumber,
          pageSize: pageSize,
          itemId: itemId,
          voteType: voteType,
          itemType:itemType);
      return _prepareGetBlogsVotes(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetBlogsVotes(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetBlogsVotes(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<BlogsVoteResponse>> _prepareGetBlogsVotes(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<BlogsVoteResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => BlogsVoteResponse.fromJson(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
