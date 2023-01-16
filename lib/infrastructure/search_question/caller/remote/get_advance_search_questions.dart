import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api/urls.dart';

class GetAdvanceSearchQuestions {
  GetAdvanceSearchQuestions({@required this.dio});
  final Dio dio;
  Map<String, dynamic> _param = Map<String, dynamic>();
  Future<dynamic> getQuestionsAdvanceSearch({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
    @required int accountTypeId,
    @required int orderByQuestions,
    @required List<String> tagsId,
    @required String personId,
  }) async {
    _param = {
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    addItemToMap("subCategoryId", subCategoryId);
    addItemToMap("personId", personId);
    addItemToMap("categoryId", categoryId);
    if (orderByQuestions != -1) _param["orderByQuestions"] = orderByQuestions;
    if (accountTypeId != -1) _param["accountTypeId"] = accountTypeId;
    if (tagsId.length != 0) _param["tagsId"] = tagsId;
    print("the param valie ddd $_param");
    Response response = await dio.get(Urls.GET_QAAS, queryParameters: _param);
    return response;
  }

  void addItemToMap(String key, String value) {
    if (value.length != 0 && value != null) {
      _param[key] = value;
    }
  }
}
