import 'package:formz/formz.dart';

enum PasswordValidationError { empty, lessThanSixChara }

class ForgetPasswordPassword extends FormzInput<String, PasswordValidationError> {
  const ForgetPasswordPassword.pure() : super.pure('');
  const ForgetPasswordPassword.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? validateLength(value)
        : PasswordValidationError.empty;
  }

  PasswordValidationError validateLength(String value) {
    return value.length > 6 ? null : PasswordValidationError.lessThanSixChara;
  }
}
