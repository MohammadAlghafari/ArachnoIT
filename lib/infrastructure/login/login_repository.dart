import 'package:arachnoit/infrastructure/login/caller/login_remote_data_request_reset_password.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import 'caller/login_local_data_provider.dart';
import 'caller/login_remote_data_login_to_server.dart';
import 'login_interface.dart';
import 'response/login_response.dart';

class LoginRepository implements LoginInterface {
  LoginRepository({
    @required this.loginLocalDataProvider,
    @required this.loginRemoteDataLoginToServer,
    @required this.loginRemoteDataRequestResetPassword,
  });

  final LoginLocalDataProvider loginLocalDataProvider;
  final LoginRemoteDataLoginToServer loginRemoteDataLoginToServer;
  final LoginRemoteDataRequestResetPassword loginRemoteDataRequestResetPassword;

  @override
  Future<ResponseWrapper<LoginResponse>> loginIntoServer(
      {@required String email,
      @required String password,
      @required String model,
      @required String product,
      @required String brand,
      @required String ip,
      @required int osApiLevel}) async {
    try {
      Response response = await loginRemoteDataLoginToServer.loginIntoServer(
          email: email,
          password: password,
          model: model,
          product: product,
          brand: brand,
          ip: ip,
          osApiLevel: osApiLevel);
      return _prepareLoginResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareLoginResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareLoginResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<bool>> requestResetPassword({String email}) async{
     try {
      Response response = await loginRemoteDataRequestResetPassword.requestResetPassword(
          email: email,
          );
      return _prepareRequestResetPasswordResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareRequestResetPasswordResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareRequestResetPasswordResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<LoginResponse> _prepareLoginResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<LoginResponse>();
    if (remoteResponse != null) {
      res.data = LoginResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
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


  ResponseWrapper<bool> _prepareRequestResetPasswordResponse(
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
