import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/vote_response.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:flutter/material.dart';

abstract class HomeBlogInterface {
  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogs({
    @required String personId,
    @required int accountTypeId,
    @required String blogId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required bool myFeed,
    @required List<String> tagsId,
    @required String query,
    @required bool isResearcher,
    @required int pageNumber,
    @required int pageSize,
    @required int orderByBlogs,
    @required bool mySubscriptionsOnly,
  });

  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForBlog({
    @required String itemId,
    @required bool status,
  });

  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForBlog({
    @required String itemId,
    @required bool status,
  });

  Future<ResponseWrapper<BriefProfileResponse>> getBriefProfile(
      {@required String id});

  Future<ResponseWrapper<bool>> sendBlogsReport(
      {String blogID, String description});
  
    Future<ResponseWrapper<bool>> deleteBlog(
      {String blogID});
}
