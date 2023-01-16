import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { noMatch, }

class ForgetPasswordConfirmPassword extends FormzInput<List<String>, ConfirmPasswordValidationError> {
  const ForgetPasswordConfirmPassword.pure([List<String> value ]) : super.pure(value);
  const ForgetPasswordConfirmPassword.dirty([List<String> value ]) : super.dirty(value);

  @override
  ConfirmPasswordValidationError validator(List<String> value) {
   return  value[0] == value[1]
        ? null
        : ConfirmPasswordValidationError.noMatch;
  }

 
}
