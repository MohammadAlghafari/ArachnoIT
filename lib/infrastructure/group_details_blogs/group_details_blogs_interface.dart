import '../api/response_wrapper.dart';
import '../home_blog/response/get_blogs_response.dart';
import 'package:flutter/material.dart';

abstract class GroupDetailsBlogsInterface {
  Future<ResponseWrapper<List<GetBlogsResponse>>> getGroupBlogs({
    @required String groupId,
    @required int pageNumber,
    @required int pageSize,
  });
}
