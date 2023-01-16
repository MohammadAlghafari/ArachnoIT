import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';

abstract class VerificationInterface {
  Future<ResponseWrapper<bool>> confirmRegistration({
    @required String email,
    @required String activationCode,
  });

  Future<ResponseWrapper<bool>> sendActivationCode({
    @required String email,
    @required String phoneNumber,
  });
}
