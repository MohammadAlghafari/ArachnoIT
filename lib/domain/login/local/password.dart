import 'package:formz/formz.dart';

enum PasswordValidationError { empty, lessThanSixChara }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

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
