import 'package:formz/formz.dart';

enum AddGroupMainGroupDropDownError { EmptyName }

class AddGroupMainGroupDropDown extends FormzInput<String, AddGroupMainGroupDropDownError> {
  const AddGroupMainGroupDropDown.pure() : super.pure('');
  const AddGroupMainGroupDropDown.dirty([String value = '']) : super.dirty(value);
  @override
  AddGroupMainGroupDropDownError validator(String value) {
    return null;
      //value?.isNotEmpty == true? null : AddGroupMainGroupDropDownError.EmptyName;
  }
}

