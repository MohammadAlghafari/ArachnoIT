import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';

abstract class SearchBlogsInterface {
  Future<ResponseWrapper<List<SubCategoryResponse>>> getSubCategory(
      {@required categoryId});
  Future<ResponseWrapper<List<CategoryResponse>>> getMainCategory();
  Future<ResponseWrapper<List<TagResponse>>> getAddTags();
  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogsAdvanceSearch({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
    @required int accountTypeId,
    @required int orderByBlogs,
    @required List<String> tagsId,
    @required bool myFeed,
    @required String personId,
  });

  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogsTextSearch({
    @required int pageNumber,
    @required int pageSize,
    @required String query,
  });
}
