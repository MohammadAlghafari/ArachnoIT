import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:flutter/material.dart';

abstract class TermsAndConditionsInterface {
  Future<ResponseWrapper<String>> getUserTerms({
    @required int termsOrPolicy,
  });
}
