import 'package:formz/formz.dart';

import '../../../common/app_const.dart';

enum RegistrationEmailValidationError { empty, emailNotValid }

class RegistrationEmail extends FormzInput<String, RegistrationEmailValidationError> {
  const RegistrationEmail.pure() : super.pure('');
  const RegistrationEmail.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationEmailValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? validateEmail(value)
        : RegistrationEmailValidationError.empty;
  }

  RegistrationEmailValidationError validateEmail(String value) {
    
    RegExp regex =  RegExp(AppConst.EMAILPATTERN);
    if (!regex.hasMatch(value))
      return RegistrationEmailValidationError.emailNotValid;
    else
      return null;
  }
}
