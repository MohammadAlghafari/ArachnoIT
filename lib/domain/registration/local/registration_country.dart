import 'package:formz/formz.dart';

enum RegistrationCountryValidationError { empty, }

class RegistrationCountry extends FormzInput<String, RegistrationCountryValidationError> {
  const RegistrationCountry.pure() : super.pure('');
  const RegistrationCountry.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationCountryValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationCountryValidationError.empty;
  }

}
