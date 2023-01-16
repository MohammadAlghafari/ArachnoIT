import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetPublicAndMyGroupsRemoteDataProvider {
  GetPublicAndMyGroupsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getPublicAndMyGroups({
    @required int publicPageNumber,
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
  }) async {
    final publicParams = {
      'pageNumber': publicPageNumber,
      'pageSize': publicPageSize,
      'enablePagination': publicEnablePagination,
      'searchString': publicSearchString,
      'healthcareProviderId': publicHealthcareProviderId,
      'approvalListOnly': publicApprovalListOnly,
      'ownershipType': publicOwnershipType,
      'categoryId': publicCategoryId,
      'subCategoryId': publicSubCategoryId,
      'mySubscriptionsOnly': publicMySubscriptionsOnly,
    };
    final myParams = {
      'pageNumber': myPageNumber,
      'pageSize': myPageSize,
      'enablePagination': myEnablePagination,
      'searchString': mySearchString,
      'healthcareProviderId': myHealthcareProviderId,
      'approvalListOnly': myApprovalListOnly,
      'ownershipType': myOwnershipType,
      'categoryId': myCategoryId,
      'subCategoryId': mySubCategoryId,
      'mySubscriptionsOnly': myMySubscriptionsOnly,
    };
    List<Response> responses = await Future.wait([
      dio.get(Urls.GET_GROUPS, queryParameters: publicParams),
      dio.get(Urls.GET_GROUPS, queryParameters: myParams),
    ]);
    return responses;
  }
}
