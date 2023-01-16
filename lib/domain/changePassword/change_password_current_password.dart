import 'package:formz/formz.dart';

enum CurrentPasswordValidationError { empty, lessThanSixChara }

class ChangePasswordCurrentPassword extends FormzInput<String, CurrentPasswordValidationError> {
  const ChangePasswordCurrentPassword.pure() : super.pure('');
  const ChangePasswordCurrentPassword.dirty([String value = '']) : super.dirty(value);

  @override
  CurrentPasswordValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : CurrentPasswordValidationError.empty;
  }

 
}
