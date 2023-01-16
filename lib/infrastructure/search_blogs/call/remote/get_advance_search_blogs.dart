import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api/urls.dart';

class GetAdvanceSearchBlogs {
  GetAdvanceSearchBlogs({@required this.dio});
  final Dio dio;
  Map<String, dynamic> _param = Map<String, dynamic>();
  Future<dynamic> getBlogsAdvanceSearch({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
    @required int accountTypeId,
    @required int orderByBlogs,
    @required List<String> tagsId,
    @required bool myFeed,
    @required String personId,
  }) async {
    _param = {
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
      "myFeed": myFeed ?? false,
    };
    addItemToMap("subCategoryId", subCategoryId);
    addItemToMap("personId", personId);
    addItemToMap("categoryId", categoryId);
    if (orderByBlogs != -1) _param["orderByBlogs"] = orderByBlogs;
    if (accountTypeId != -1) _param["accountTypeId"] = accountTypeId;
    if (tagsId.length != 0) _param["tagsId"] = tagsId;
    print("the param valie ddd $_param");
    Response response = await dio.get(Urls.GET_BLOGS, queryParameters: _param);
    return response;
  }

  void addItemToMap(String key, String value) {
    if (value.length != 0 && value != null) {
      _param[key] = value;
    }
  }
}
