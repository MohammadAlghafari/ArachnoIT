import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/registration_socail/caller/login_with_google.dart';
import 'package:arachnoit/infrastructure/registration_socail/caller/validate_google_token.dart';
import 'package:arachnoit/infrastructure/registration_socail/registration_socail_interface.dart';
import 'package:arachnoit/infrastructure/registration_socail/response/social_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import 'caller/login_with_facebook.dart';
import 'caller/validate_facebook_token.dart';

class RegistrationSocailRepository implements RegistraionSocailInterface {
  ValidateFaceBookToken validateFaceBookToken;
  LoginWithFaceBook loginWithFaceBook;
  ValidateGoogleToken validateGoogleToken;
  LoginWithGoogle loginWithGoogle;
  RegistrationSocailRepository(
      {@required this.validateFaceBookToken, @required this.loginWithFaceBook
      ,
      @required this.validateGoogleToken, @required this.loginWithGoogle});

  @override
  Future<ResponseWrapper<SocialResponse>> facebookValidationToken(
      {@required String token}) async {
    try {
      Response data = await validateFaceBookToken.sendValidation(token: token);
      return _prepareFacebookValidationToken(remoteResponse: data);
    } on DioError catch (e) {
      print("The error is $e");
      return null;
    } catch (e) {
      print("The error is $e");
      return null;
    }
  }

  ResponseWrapper<SocialResponse> _prepareFacebookValidationToken(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<SocialResponse>();
    if (remoteResponse != null) {
      res.data = SocialResponse.fromJson(remoteResponse.data);
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

  @override
  Future<ResponseWrapper<LoginResponse>> faceBookLogin({
    @required String token,
    @required String email,
    @required String model,
    @required String product,
    @required String brand,
    @required String ip,
    @required int osApiLevel,
    @required bool rememberMe,
    @required String fcmId,
  }) async {
    try {
      Response data = await loginWithFaceBook.sendLoginFaceBook(
          token: token,
          brand: brand,
          email: email,
          fcmId: fcmId,
          ip: ip,
          model: model,
          osApiLevel: osApiLevel,
          product: product,
          rememberMe: rememberMe);
      return _prepareFaceBookLogin(remoteResponse: data);
    } on DioError catch (e) {
      print("The error is $e");
      return null;
    } catch (e) {
      print("The error is $e");
      return null;
    }
  }

  ResponseWrapper<LoginResponse> _prepareFaceBookLogin(
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

  @override
  Future<ResponseWrapper<LoginResponse>> googleLogin({
    @required String token,
    @required String email,
    @required String model,
    @required String product,
    @required String brand,
    @required String ip,
    @required int osApiLevel,
    @required bool rememberMe,
    @required String fcmId,
  }) async {
    try {
      Response data = await loginWithGoogle.sendLoginGoogle(
          token: token,
          brand: brand,
          email: email,
          fcmId: fcmId,
          ip: ip,
          model: model,
          osApiLevel: osApiLevel,
          product: product,
          rememberMe: rememberMe);
      return _prepareFaceBookLogin(remoteResponse: data);
    } on DioError catch (e) {
      print("The error is $e");
      return null;
    } catch (e) {
      print("The error is $e");
      return null;
    }
  }

  @override
  Future<ResponseWrapper<SocialResponse>> googleValidationToken(
      {@required String token}) async {
    try {
      Response data = await validateGoogleToken.sendValidation(token: token);
      return _prepareFacebookValidationToken(remoteResponse: data);
    } on DioError catch (e) {
      print("The error is $e");
      return null;
    } catch (e) {
      print("The error is $e");
      return null;
    }
  }
}
