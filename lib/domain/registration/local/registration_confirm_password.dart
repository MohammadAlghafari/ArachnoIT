import 'package:formz/formz.dart';

enum RegistrationConfirmPasswordValidationError { noMatch, }

class RegistrationConfirmPassword extends FormzInput<List<String>, RegistrationConfirmPasswordValidationError> {
  const RegistrationConfirmPassword.pure([List<String> value ]) : super.pure(value);
  const RegistrationConfirmPassword.dirty([List<String> value ]) : super.dirty(value);

  @override
  RegistrationConfirmPasswordValidationError validator(List<String> value) {
    return value[0] == value[1]
        ? null
        : RegistrationConfirmPasswordValidationError.noMatch;
  }

 
}
