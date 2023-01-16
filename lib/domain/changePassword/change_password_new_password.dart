import 'package:formz/formz.dart';

enum NewPasswordValidationError { empty, matchCurrent }

class ChangePasswordNewPassword
    extends FormzInput<List<String>, NewPasswordValidationError> {
  const ChangePasswordNewPassword.pure([List<String> value])
      : super.pure(value);
  const ChangePasswordNewPassword.dirty([List<String> value])
      : super.dirty(value);

  @override
  NewPasswordValidationError validator(List<String> value) {
    return value[0].isNotEmpty == true
                ? validateMatch(value)
                : NewPasswordValidationError.empty;
  }

  NewPasswordValidationError validateMatch(List<String> value) {
    return value[0] != value[1]
        ? null
        : NewPasswordValidationError.matchCurrent;
  }
}
