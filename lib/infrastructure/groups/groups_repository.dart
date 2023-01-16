import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/groups/caller/get_my_groups_remote_Data_provider.dart';
import 'package:arachnoit/infrastructure/groups/caller/get_public_and_my_groups_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/groups/groups_interface.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:flutter/material.dart';
import '../api/response_type.dart' as ResType;
import 'package:dio/dio.dart';

class GroupsRepository implements GroupsInterface {
  GroupsRepository({
    this.getMyGroupsRemoteDataProvider,
    this.getPublicAndMyGroupsRemoteDataProvider,
  });
  final GetMyGroupsRemoteDataProvider getMyGroupsRemoteDataProvider;
  final GetPublicAndMyGroupsRemoteDataProvider
      getPublicAndMyGroupsRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<GroupResponse>>> getMyGroups(
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
      Response response = await getMyGroupsRemoteDataProvider.getMyGroups(
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

  @override
  Future<ResponseWrapper<List<dynamic>>> getPublicAndMyGroups(
      {int publicPageNumber,
      int publicPageSize,
      bool publicEnablePagination,
      String publicSearchString,
      String publicHealthcareProviderId,
      bool publicApprovalListOnly,
      int publicOwnershipType,
      String publicCategoryId,
      String publicSubCategoryId,
      bool publicMySubscriptionsOnly,
      int myPageNumber,
      int myPageSize,
      bool myEnablePagination,
      String mySearchString,
      String myHealthcareProviderId,
      bool myApprovalListOnly,
      int myOwnershipType,
      String myCategoryId,
      String mySubCategoryId,
      bool myMySubscriptionsOnly}) async {
    try {
      List<Response> responses =
          await getPublicAndMyGroupsRemoteDataProvider.getPublicAndMyGroups(
        publicPageNumber: publicPageNumber,
        publicPageSize: publicPageSize,
        publicEnablePagination: publicEnablePagination,
        publicSearchString: publicSearchString,
        publicHealthcareProviderId: publicHealthcareProviderId,
        publicApprovalListOnly: publicApprovalListOnly,
        publicOwnershipType: publicOwnershipType,
        publicCategoryId: publicCategoryId,
        publicSubCategoryId: publicSubCategoryId,
        publicMySubscriptionsOnly: publicMySubscriptionsOnly,
        myPageNumber: myPageNumber,
        myPageSize: myPageSize,
        myEnablePagination: myEnablePagination,
        mySearchString: mySearchString,
        myHealthcareProviderId: myHealthcareProviderId,
        myApprovalListOnly: myApprovalListOnly,
        myOwnershipType: myOwnershipType,
        myCategoryId: myCategoryId,
        mySubCategoryId: mySubCategoryId,
        myMySubscriptionsOnly: myMySubscriptionsOnly,
      );
      return _preparePublicAndMyGroupsResponse(
        remoteResponses: responses,
      );
    } catch (e) {
      return e;
    }
  }

  ResponseWrapper<List<dynamic>> _preparePublicAndMyGroupsResponse(
      {@required List<Response> remoteResponses}) {
    var res = ResponseWrapper<List<dynamic>>();
    if (remoteResponses != null) {
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      res.data = [];
      res.data.add((remoteResponses[0].data as List)
          .map((x) => GroupResponse.fromMap(x))
          .toList());
      res.data.add((remoteResponses[1].data as List)
          .map((x) => GroupResponse.fromMap(x))
          .toList());
      if (remoteResponses[0].statusCode == 200 &&
          remoteResponses[1].statusCode == 200)
        res.responseType = ResType.ResponseType.SUCCESS;
      else if (remoteResponses[0].statusCode == 400 ||
          remoteResponses[1].statusCode == 400 ||
          remoteResponses[0].statusCode == 401 ||
          remoteResponses[1].statusCode == 401)
        res.responseType = ResType.ResponseType.VALIDATION_ERROR;
      else if (remoteResponses[0].statusCode == 500 ||
          remoteResponses[1].statusCode == 500)
        res.responseType = ResType.ResponseType.SERVER_ERROR;
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
