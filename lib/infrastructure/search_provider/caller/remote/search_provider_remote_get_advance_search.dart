import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SearchRemoteProviderGetAdvanceSearch {
  final Dio dio;
  Map<String, dynamic> _param = new Map<String, dynamic>();
  SearchRemoteProviderGetAdvanceSearch({@required this.dio});
  Future<dynamic> getAdvanceSearchProvider(
      {String accountTypeId = "",
      String cityId = "",
      String countryId = "",
      int gender,
      String serviceId = "",
      List<String> specificationsIds = const <String>[],
      String subSpecificationId = "",
      int pageNumber,
      int pageSize}) async {
    _param = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    addItemToMap("accountTypeId", accountTypeId);
    addItemToMap("cityId", cityId);
    addItemToMap("countryId", countryId);
    addItemToMap("subSpecificationId", subSpecificationId);
    addItemToMap("serviceId", serviceId);
    if (gender != null && gender != -1) _param["gender"] = gender;
    if (specificationsIds.length != 0 && specificationsIds != null)
      _param["specificationsIds"] = specificationsIds;

    Response response =
        await dio.get(Urls.AdVANCE_SEARCH_PROVIDER, queryParameters: _param);
    return response;
  }

  void addItemToMap(String key, String value) {
    if (value.length != 0 && value != null) {
      _param[key] = value;
    }
  }
}
