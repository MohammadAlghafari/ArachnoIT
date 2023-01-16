import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { noMatch, }

class ChangePasswordConfirmPassword extends FormzInput<List<String>, ConfirmPasswordValidationError> {
  const ChangePasswordConfirmPassword.pure([List<String> value ]) : super.pure(value);
  const ChangePasswordConfirmPassword.dirty([List<String> value ]) : super.dirty(value);

  @override
  ConfirmPasswordValidationError validator(List<String> value) {
    return  value[0] == value[1]
        ? null
        : ConfirmPasswordValidationError.noMatch;
  }

 
}
