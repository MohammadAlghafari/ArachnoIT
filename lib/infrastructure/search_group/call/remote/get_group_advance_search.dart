import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetGroupAdvanceSearch {
  GetGroupAdvanceSearch({@required this.dio});
  final Dio dio;
  Map<String,dynamic>_param=Map<String,dynamic>();
  Future<dynamic> getAdvanceSearchGroups(
      {int pageNumber,
      int pageSize,
      String searchText,
      String categoryId,
      String subCategoryID,
      String userId,
      }) async {
     _param = {
      'enablePagination': true,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "healthcareProviderId": userId,
      "approvalListOnly": false,
      "mySubscriptionsOnly": false,
      'ownershipType': 3,
    };
    addItemToMap("categoryId",categoryId);
    addItemToMap("subCategoryID",subCategoryID);
    Response response = await dio.get(
      Urls.GET_GROUPS,
      queryParameters: _param,
    );
    return response;
  }
    void addItemToMap(String key, String value) {
    if (value.length != 0 && value != null) {
      _param[key] = value;
    }
  }
}
