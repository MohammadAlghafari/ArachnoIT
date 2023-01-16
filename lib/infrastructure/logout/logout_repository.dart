import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/logout/caller/logout_user_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/logout/logout_interface.dart';
import '../api/response_type.dart' as ResType;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LogoutRepsitory implements LogoutInterface {
  LogoutRepsitory({
    @required this.logoutUserRemoteDataProvider,
  });
  final LogoutUserRemoteDataProvider logoutUserRemoteDataProvider;

  @override
  Future<ResponseWrapper<bool>> logoutUser(
      {String model,
      String product,
      String brand,
      String ip,
      int osApiLevel}) async {
    try {
      Response response = await logoutUserRemoteDataProvider.logoutUser(
          model: model,
          product: product,
          brand: brand,
          ip: ip,
          osApiLevel: osApiLevel);
      return _prepareLogoutResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareLogoutResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareLogoutResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<bool> _prepareLogoutResponse(
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
