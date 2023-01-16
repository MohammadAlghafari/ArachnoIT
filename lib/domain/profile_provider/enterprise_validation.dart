import 'package:formz/formz.dart';

enum EnterpriseValidationErrors { EmptyName }

class EnterpriseValidation extends FormzInput<String, EnterpriseValidationErrors> {
  const EnterpriseValidation.pure() : super.pure('');
  const EnterpriseValidation.dirty([String value = '']) : super.dirty(value);
  @override
  EnterpriseValidationErrors validator(String value) {
    return value?.isNotEmpty == true ? null : EnterpriseValidationErrors.EmptyName;
  }
}
