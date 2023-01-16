import 'package:formz/formz.dart';

enum RegistrationTouchPointNameValidationError { empty, lessThanFiveChara}

class RegistrationTouchPointName extends FormzInput<String, RegistrationTouchPointNameValidationError> {
  const RegistrationTouchPointName.pure() : super.pure('');
  const RegistrationTouchPointName.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationTouchPointNameValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? validateLength(value)
        : RegistrationTouchPointNameValidationError.empty;
  }

  RegistrationTouchPointNameValidationError validateLength(String value) {
    return value.length > 5 ? null : RegistrationTouchPointNameValidationError.lessThanFiveChara;
  }

}
