import 'package:formz/formz.dart';

enum RegistrationQualificationValidationError { empty, }

class RegistrationQualification extends FormzInput<String, RegistrationQualificationValidationError> {
  const RegistrationQualification.pure() : super.pure('');
  const RegistrationQualification.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationQualificationValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationQualificationValidationError.empty;
  }

}
