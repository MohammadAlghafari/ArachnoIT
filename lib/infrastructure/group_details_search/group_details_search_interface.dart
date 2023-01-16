import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/tag_response.dart';
import 'package:flutter/material.dart';

abstract class GroupDetailsSearchInterface {
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories();

  Future<ResponseWrapper<List<SubCategoryResponse>>> getSubCategories({
    @required categoryId,
  });

  Future<ResponseWrapper<List<TagResponse>>> getAddTags();

}
