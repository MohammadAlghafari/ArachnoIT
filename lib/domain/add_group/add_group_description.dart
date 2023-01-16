import 'package:formz/formz.dart';

enum AddGroupDescirptionError { EmptyName }

class AddGroupDescription extends FormzInput<String, AddGroupDescirptionError> {
  const AddGroupDescription.pure() : super.pure('');
  const AddGroupDescription.dirty([String value = '']) : super.dirty(value);
  @override
  AddGroupDescirptionError validator(String value) {
    return value?.isNotEmpty == true? null : AddGroupDescirptionError.EmptyName;
  }
}
