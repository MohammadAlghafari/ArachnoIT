import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';

abstract class ChangePasswordInterface {
 

       Future<ResponseWrapper<bool>> cahngePassword(
      {
        @required String currentPassword,
        @required String newPassword,
        @required String confirmPassword,
      });
}
