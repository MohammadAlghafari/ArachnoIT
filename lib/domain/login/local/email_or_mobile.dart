import 'package:formz/formz.dart';

import '../../../common/app_const.dart';

enum EmailOrMobileValidationError { empty, emailNotValid }

class EmailOrMobile extends FormzInput<String, EmailOrMobileValidationError> {
  const EmailOrMobile.pure() : super.pure('');
  const EmailOrMobile.dirty([String value = '']) : super.dirty(value);

  @override
  EmailOrMobileValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? validateEmail(value)
        : EmailOrMobileValidationError.empty;
  }

  EmailOrMobileValidationError validateEmail(String value) {
    RegExp regex = RegExp(AppConst.EMAILPATTERN);
    if (!regex.hasMatch(value))
      return EmailOrMobileValidationError.emailNotValid;
    else
      return null;
  }
}
