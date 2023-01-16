import 'package:formz/formz.dart';

enum IssueDateValidationErros { EmptyName }

class IssueDateValidation extends FormzInput<String, IssueDateValidationErros> {
  const IssueDateValidation.pure() : super.pure('');
  const IssueDateValidation.dirty([String value = '']) : super.dirty(value);
  @override
  IssueDateValidationErros validator(String value) {
    return value?.isNotEmpty == true ? null : IssueDateValidationErros.EmptyName;
  }
}
