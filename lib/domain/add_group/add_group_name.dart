import 'package:formz/formz.dart';

enum AddGroupNameError { EmptyName }

class AddGroupName extends FormzInput<String, AddGroupNameError> {
  const AddGroupName.pure() : super.pure('');
  const AddGroupName.dirty([String value]) : super.dirty(value);
  @override
  AddGroupNameError validator(String value) {
    return value?.isNotEmpty == true ? null : AddGroupNameError.EmptyName;
  }
}
