import 'package:formz/formz.dart';

enum RegistrationSpecialityValidationError { empty, }

class RegistrationSpeciality extends FormzInput<String, RegistrationSpecialityValidationError> {
  const RegistrationSpeciality.pure() : super.pure('');
  const RegistrationSpeciality.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationSpecialityValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationSpecialityValidationError.empty;
  }

}
