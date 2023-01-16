import 'package:formz/formz.dart';

enum RegistrationCityValidationError { empty, }

class RegistrationCity extends FormzInput<String, RegistrationCityValidationError> {
  const RegistrationCity.pure() : super.pure('');
  const RegistrationCity.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationCityValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationCityValidationError.empty;
  }

}
