import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:flutter/material.dart';

abstract class DiscoverCategoriesSubCategoryAllBlogsInterface {
  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoryBlogs({
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  });
}
