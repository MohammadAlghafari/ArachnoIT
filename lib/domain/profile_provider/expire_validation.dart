import 'package:formz/formz.dart';

enum ExpireDateValidationErrors { EmptyName }

class ExpireDateValidation extends FormzInput<String, ExpireDateValidationErrors> {
  const ExpireDateValidation.pure() : super.pure('');
  const ExpireDateValidation.dirty([String value = '']) : super.dirty(value);
  @override
  ExpireDateValidationErrors validator(String value) {
    return value?.isNotEmpty == true ? null : ExpireDateValidationErrors.EmptyName;
  }
}
