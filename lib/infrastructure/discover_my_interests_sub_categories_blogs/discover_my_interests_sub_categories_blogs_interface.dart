import '../api/response_wrapper.dart';
import '../home_blog/response/get_blogs_response.dart';
import 'package:flutter/cupertino.dart';

abstract class DiscoverMyInterestsSubCategoriesBlogsInterface {
  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoriesBlogs({
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  });
}
