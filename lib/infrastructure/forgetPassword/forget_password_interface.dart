import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';

abstract class ForgetPasswordInterface {
  Future<ResponseWrapper<bool>> resetPassword(
      {@required String newPassword,
      @required String confirmPassword,
      @required String email,
      @required String token,
      });
}
