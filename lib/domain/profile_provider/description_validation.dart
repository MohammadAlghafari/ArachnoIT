import 'package:formz/formz.dart';

enum DescriptionValidationError { EmptyName }

class DescriptionValidation extends FormzInput<String, DescriptionValidationError> {
  const DescriptionValidation.pure() : super.pure('');
  const DescriptionValidation.dirty([String value = '']) : super.dirty(value);
  @override
  DescriptionValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : DescriptionValidationError.EmptyName;
  }
}
