import 'package:formz/formz.dart';

enum RegistrationFirstNameValidationError { empty, emailNotValid}

class RegistrationFirstName extends FormzInput<String, RegistrationFirstNameValidationError> {
  const RegistrationFirstName.pure() : super.pure('');
  const RegistrationFirstName.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationFirstNameValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationFirstNameValidationError.empty;
  }

 
}
