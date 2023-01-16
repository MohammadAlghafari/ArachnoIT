import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetGroupSearchText {
  GetGroupSearchText({@required this.dio});
  final Dio dio;

  Future<dynamic> getGroupsSearchText(
      {int pageNumber,
      int pageSize,
      String searchText,
      String categoryId,
      String subCategoryID,
      String userID}) async {
    final params = {
      'enablePagination': true,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "healthcareProviderId": userID,
      "approvalListOnly": false,
      "mySubscriptionsOnly": false,
      'ownershipType': 3,
      "searchString": searchText
    };
    Response response = await dio.get(
      Urls.GET_GROUPS,
      queryParameters: params,
    );
    return response;
  }
}
