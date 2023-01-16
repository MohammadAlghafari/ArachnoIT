import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/group_response.dart';

abstract class DiscoverCategoriesSubCategoryAllGroupsInterface {
  Future<ResponseWrapper<List<GroupResponse>>> getSubCategoryAllGroups({
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
}
