import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:flutter/material.dart';

abstract class AllGroupsInterface{

  Future<ResponseWrapper<List<GroupResponse>>> getPublicGroups(
      { @required int pageNumber,
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