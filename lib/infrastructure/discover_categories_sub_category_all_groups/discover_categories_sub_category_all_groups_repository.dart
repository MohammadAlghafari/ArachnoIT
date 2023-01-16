import 'package:arachnoit/infrastructure/discover_categories_sub_category_all_groups/caller/get_sub_category_all_groups_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:flutter/material.dart';
import '../api/response_type.dart' as ResType;
import 'package:dio/dio.dart';

import 'discover_categories_sub_category_all_groups_interface.dart';

class DiscoverCategoriesSubCategoryAllGroupsRepository
    implements DiscoverCategoriesSubCategoryAllGroupsInterface {
  DiscoverCategoriesSubCategoryAllGroupsRepository(
      {this.getSubCategoryAllGroupsRemoteDataProvider});
  final GetSubCategoryAllGroupsRemoteDataProvider
      getSubCategoryAllGroupsRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<GroupResponse>>> getSubCategoryAllGroups(
      {int pageNumber,
      int pageSize,
      bool enablePagination,
      String searchString,
      String healthcareProviderId,
      bool approvalListOnly,
      int ownershipType,
      String categoryId,
      String subCategoryId,
      bool mySubscriptionsOnly}) async {
    try {
      Response response = await getSubCategoryAllGroupsRemoteDataProvider
          .getSubCategoryAllGroups(
        pageNumber: pageNumber,
        pageSize: pageSize,
        enablePagination: enablePagination,
        searchString: searchString,
        healthcareProviderId: healthcareProviderId,
        approvalListOnly: approvalListOnly,
        ownershipType: ownershipType,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        mySubscriptionsOnly: mySubscriptionsOnly,
      );
      return _prepareGroupsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGroupsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGroupsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<GroupResponse>> _prepareGroupsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GroupResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => GroupResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
