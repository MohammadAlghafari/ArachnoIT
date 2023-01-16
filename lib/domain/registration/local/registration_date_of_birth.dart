import 'package:formz/formz.dart';

enum RegistrationDateOfBirthValidationError { empty, }

class RegistrationDateOfBirth extends FormzInput<String, RegistrationDateOfBirthValidationError> {
  const RegistrationDateOfBirth.pure() : super.pure('');
  const RegistrationDateOfBirth.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationDateOfBirthValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationDateOfBirthValidationError.empty;
  }

}
