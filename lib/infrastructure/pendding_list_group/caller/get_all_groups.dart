import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetAllPenddingGroups {
  GetAllPenddingGroups({@required this.dio});
  final Dio dio;
  Map<String, dynamic> _param = Map<String, dynamic>();
  Future<dynamic> getAdvanceSearchGroups({
    int pageNumber,
    int pageSize,
    String userId,
  }) async {
    _param = {
      'enablePagination': true,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "healthcareProviderId": userId,
      "approvalListOnly": true,
      "mySubscriptionsOnly": false,
      'ownershipType': 0,
    };
    Response response = await dio.get(
      Urls.GET_GROUPS,
      queryParameters: _param,
    );
    return response;
  }
}
