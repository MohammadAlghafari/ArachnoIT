import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../login/response/login_response.dart';

abstract class LoginInterface {
  Future<ResponseWrapper<LoginResponse>> loginIntoServer(
      {@required String email,
      @required String password,
      @required String model,
      @required String product,
      @required String brand,
      @required String ip,
      @required int osApiLevel});

       Future<ResponseWrapper<bool>> requestResetPassword(
      {@required String email,
      });
}
