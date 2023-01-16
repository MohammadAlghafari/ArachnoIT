import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class SetProviderGeneralInfo {
  SetProviderGeneralInfo({@required this.dio});

  final Dio dio;

  Future<dynamic> setProviderGeneralInfo({
    String firstName,
    String lastName,
    String inTouchPointName,
    String subSpecificationId,
    String organizationTypeId,
    int gender,
    String birthdate,
    String summary,
  }) async {
    final providerGeneralInfo = {
      "firstName": firstName,
      "lastName": lastName,
      "inTouchPointName": inTouchPointName,
      "subSpecification": subSpecificationId,
      "organizationTypeId": organizationTypeId,
    };
    final generalInfo = {
      "firstName": firstName,
      "lastName": lastName,
      "gender": gender,
      "birthdate": birthdate,
      "summary": summary
    };
    List<Response> responses = await Future.wait([
      dio.put(Urls.EDIT_PROVIDER_GENERAL_INFO, data: providerGeneralInfo),
      dio.put(Urls.EDIT_GENERAL_INFO, data: generalInfo),
    ]);
    return responses;
  }
}
