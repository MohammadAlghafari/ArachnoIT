import 'package:formz/formz.dart';

import '../../../common/app_const.dart';

enum ForgetPasswordEmailValidationError { empty, emailNotValid }

class ForgetPasswordEmail extends FormzInput<String, ForgetPasswordEmailValidationError> {
  const ForgetPasswordEmail.pure() : super.pure('');
  const ForgetPasswordEmail.dirty([String value = '']) : super.dirty(value);

  @override
  ForgetPasswordEmailValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? validateEmail(value)
        : ForgetPasswordEmailValidationError.empty;
  }

  ForgetPasswordEmailValidationError validateEmail(String value) {
    RegExp regex = RegExp(AppConst.EMAILPATTERN);
    if (!regex.hasMatch(value))
      return ForgetPasswordEmailValidationError.emailNotValid;
    else
      return null;
  }
}
