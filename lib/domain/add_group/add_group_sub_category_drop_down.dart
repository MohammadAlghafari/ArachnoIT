import 'package:formz/formz.dart';

enum AddGroupSubCategoryDropDownError { EmptyName }

class AddGroupSubCategoryDropDown extends FormzInput<String, AddGroupSubCategoryDropDownError> {
  const AddGroupSubCategoryDropDown.pure() : super.pure('');
  const AddGroupSubCategoryDropDown.dirty([String value = '']) : super.dirty(value);
  @override
  AddGroupSubCategoryDropDownError validator(String value) {
    return value?.isNotEmpty == true? null : AddGroupSubCategoryDropDownError.EmptyName;
  }
}

