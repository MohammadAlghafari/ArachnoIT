import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/group_response.dart';

abstract class DiscoverCategoriesDetailsInterface {
  Future<ResponseWrapper<List<GroupResponse>>> getSubCategoryGroups({
    @required int pageNumber,
    @required int pageSize,
    @required bool enablePagination,
    @required String searchString,
    @required String healthcareProviderId,
    @required bool approvalListOnly,
    @required int ownershipType,
    @required String categoryId,
    @required String subCategoryId,
    @required bool mySubscriptionsOnly,
  });

  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoryBlogs({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  });

  Future<ResponseWrapper<List<QaaResponse>>> getSubCategoryQuestions({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  });
}
