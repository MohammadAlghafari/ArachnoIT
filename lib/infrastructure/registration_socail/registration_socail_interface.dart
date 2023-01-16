import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/registration_socail/response/social_response.dart';
import 'package:flutter/cupertino.dart';

abstract class RegistraionSocailInterface {
  Future<ResponseWrapper<SocialResponse>> facebookValidationToken({@required String token});

  Future<ResponseWrapper<LoginResponse>> faceBookLogin({  @required String token,
    @required String email,
    @required String model,
    @required String product,
    @required String brand,
    @required String ip,
    @required int osApiLevel,
    @required bool rememberMe,
    @required String fcmId,});




  Future<ResponseWrapper<SocialResponse>> googleValidationToken({@required String token});

  Future<ResponseWrapper<LoginResponse>> googleLogin({  @required String token,
    @required String email,
    @required String model,
    @required String product,
    @required String brand,
    @required String ip,
    @required int osApiLevel,
    @required bool rememberMe,
    @required String fcmId,});



}
