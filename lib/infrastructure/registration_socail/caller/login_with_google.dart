import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoginWithGoogle {
  final Dio dio;
  LoginWithGoogle({@required this.dio});
  Future<dynamic> sendLoginGoogle({
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
    final _param = {
      "email": email,
      "rememberMe": rememberMe,
      "fcmId": fcmId,
      "model": model,
      "product": product,
      "brand": brand,
      "ip": ip,
      "osApiLevel": osApiLevel
    };
    Response response = await dio.post(Urls.LOGIN_WITH_GOOGLE, data: _param,queryParameters: {
      "accessToken": token,
    });
    return response;
  }
}
