import 'package:formz/formz.dart';

enum RegistrationLastNameValidationError { empty, }

class RegistrationLastName extends FormzInput<String, RegistrationLastNameValidationError> {
  const RegistrationLastName.pure() : super.pure('');
  const RegistrationLastName.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationLastNameValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationLastNameValidationError.empty;
  }

}
