import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

class HandleResponse<T> {
  getResponseWrapper({
    @required Function(dynamic x) convertResposeFunction,
    @required Response<dynamic> response,
    // ignore: avoid_init_to_null
    Function(dynamic x) needMyOwnConvertFunction = null,
    bool responseWithErrorMessage=false,
  }) {
    ResponseWrapper<T> res = ResponseWrapper<T>();
    bool myOwnFunction = false;
    if (needMyOwnConvertFunction != null) myOwnFunction = true;
    if (response != null) {
      res.data = !myOwnFunction
          ? convertResposeFunction(response.data)
          : needMyOwnConvertFunction(response);
      res.enumResult = responseWithErrorMessage  ? response.data[AppConst.ENUM_RESULT] as int : null;
      res.errorMessage =
          responseWithErrorMessage ? response.data[AppConst.ERROR_MESSAGES] as String : null;
      res.successEnum =
          responseWithErrorMessage ? response.data[AppConst.SUCCESS_ENUM] as int : null;
      res.successMessage =
          responseWithErrorMessage ? response.data[AppConst.SUCCESS_MESSAGE] as String : null;
      res.opertationName =
          responseWithErrorMessage ? response.data[AppConst.OPERATON_NAME] as String : null;
      switch (response.statusCode) {
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
