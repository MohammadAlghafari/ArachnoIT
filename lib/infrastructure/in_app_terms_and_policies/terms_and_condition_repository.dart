import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/in_app_terms_and_policies/terms_and_condition_interface.dart';
import 'package:dio/dio.dart';
import '../api/response_type.dart' as ResType;
import 'package:flutter/material.dart';

import 'caller/get_terms_and_condition.dart';

class TermsAndConditionsRepository implements TermsAndConditionsInterface {
  final GetTermsAndConditions getTermsAndConditions;

  TermsAndConditionsRepository({
    @required this.getTermsAndConditions,
  });

  @override
  Future<ResponseWrapper<String>> getUserTerms({
    @required int termsOrPolicy,
  }) async {
    try {
      print("Type here $termsOrPolicy");
      Response response = await getTermsAndConditions.getTermsAndConditionsInfo(
        termsOrPolicy: termsOrPolicy,
      );
      return _prepareGetTermsInfo(remoteResponse: response);
    } on DioError catch (e) {
      print("the error  is Dio$e");

      return _prepareGetTermsInfo(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareGetTermsInfo(remoteResponse: null);
    }
  }

  ResponseWrapper<String> _prepareGetTermsInfo({
    @required Response<dynamic> remoteResponse,
  }) {
    var res = ResponseWrapper<String>();
    if (remoteResponse != null) {
      res.data = remoteResponse.data;
      print("resposne is ${res.data}");
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
