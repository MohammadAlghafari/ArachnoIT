import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:flutter/material.dart';

abstract class GroupDetailsSearchBlogsInterface {
  Future<ResponseWrapper<List<GetBlogsResponse>>> getSearchTextBlogs({
    @required String groupId,
    @required String query,
    @required int pageNumber,
    @required int pageSize,
  });

  Future<ResponseWrapper<List<GetBlogsResponse>>> getAdvancedSearchBlogs({
    @required int accountTypeId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required List<String> tagsId,
    @required int pageNumber,
    @required int pageSize,
  });
}
