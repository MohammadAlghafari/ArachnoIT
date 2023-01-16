import 'package:formz/formz.dart';

enum TitleValidationErrors { EmptyName }

class TitleValidation extends FormzInput<String, TitleValidationErrors> {
  const TitleValidation.pure() : super.pure('');
  const TitleValidation.dirty([String value = '']) : super.dirty(value);
  @override
  TitleValidationErrors validator(String value) {
    return value?.isNotEmpty == true ? null : TitleValidationErrors.EmptyName;
  }
}
