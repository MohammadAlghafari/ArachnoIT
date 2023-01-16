import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetContactInfo {
  final Dio dio;
  SetContactInfo({@required this.dio});
  Future<dynamic> setContactInfo({
    String personId,
    String cityId,
    String phone,
    String workPhone,
    String mobile,
    String address,
  }) async {
    final _param = {
      "personId": personId,
      "cityId": cityId,
      "phone": phone,
      "workPhone": workPhone,
      "mobile": mobile,
      "address": address
    };
    Response response = await dio.put(Urls.SET_CONTACT_INFO, data: _param);
    return response;
  }
}
