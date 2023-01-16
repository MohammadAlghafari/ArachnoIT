import 'package:formz/formz.dart';

enum RegistrationPasswordValidationError { empty, lessThanSixChara }

class RegistrationPassword extends FormzInput<String, RegistrationPasswordValidationError> {
  const RegistrationPassword.pure() : super.pure('');
  const RegistrationPassword.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationPasswordValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? validateLength(value)
        : RegistrationPasswordValidationError.empty;
  }

 RegistrationPasswordValidationError validateLength(String value) {
    return value.length > 6 ? null : RegistrationPasswordValidationError.lessThanSixChara;
  }
}
