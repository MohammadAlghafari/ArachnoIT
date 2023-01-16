import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetSubCategoryAllGroupsRemoteDataProvider {
  GetSubCategoryAllGroupsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getSubCategoryAllGroups({
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
  }) async {
    final params = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'enablePagination': enablePagination,
      'searchString': searchString,
      'healthcareProviderId': healthcareProviderId,
      'approvalListOnly': approvalListOnly,
      'ownershipType': ownershipType,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'mySubscriptionsOnly': mySubscriptionsOnly,
    };
    Response response = await dio.get(Urls.GET_GROUPS, queryParameters: params);
    return response;
  }
}
