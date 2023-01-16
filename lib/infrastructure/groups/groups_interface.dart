import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:flutter/material.dart';

abstract class GroupsInterface{

  Future<ResponseWrapper<List<GroupResponse>>> getMyGroups(
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

  Future<ResponseWrapper<List<dynamic>>> getPublicAndMyGroups(
      { @required int publicPageNumber,
    @required int publicPageSize,
    @required bool publicEnablePagination,
    @required String publicSearchString,
    @required String publicHealthcareProviderId,
    @required bool publicApprovalListOnly,
    @required int publicOwnershipType,
    @required String publicCategoryId,
    @required String publicSubCategoryId,
    @required bool publicMySubscriptionsOnly,
    @required int myPageNumber,
    @required int myPageSize,
    @required bool myEnablePagination,
    @required String mySearchString,
    @required String myHealthcareProviderId,
    @required bool myApprovalListOnly,
    @required int myOwnershipType,
    @required String myCategoryId,
    @required String mySubCategoryId,
    @required bool myMySubscriptionsOnly,
      });
}