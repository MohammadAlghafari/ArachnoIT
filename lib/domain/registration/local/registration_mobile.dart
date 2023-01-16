import 'package:formz/formz.dart';

enum RegistrationMobileValidationError { empty, lessThanSixChara }

class RegistrationMobile extends FormzInput<String, RegistrationMobileValidationError> {
  const RegistrationMobile.pure() : super.pure('');
  const RegistrationMobile.dirty([String value = '']) : super.dirty(value);

  @override
  RegistrationMobileValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : RegistrationMobileValidationError.empty;
  }

 
}
