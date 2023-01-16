import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import 'caller/forget_password_remote_data_reset_password.dart';
import 'forget_password_interface.dart';

class ForgetPasswordRepository implements ForgetPasswordInterface {
  ForgetPasswordRepository({
  @required this.forgetPasswordRemoteDataResetPassword,
  });
  
  final ForgetPasswordRemoteDataResetPassword forgetPasswordRemoteDataResetPassword;
  @override
  Future<ResponseWrapper<bool>> resetPassword({String newPassword, String confirmPassword, String email, String token}) async {
     try {
      Response response = await forgetPasswordRemoteDataResetPassword.resetPassword(
          newPassword: newPassword,
          confirmPassword: confirmPassword,
          email: email,
          token: token,
          );
      return _prepareResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareResponse(
        remoteResponse: null,
      );
    }
  }

   ResponseWrapper<bool> _prepareResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      res.data = remoteResponse.data[AppConst.ENTITY];
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
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