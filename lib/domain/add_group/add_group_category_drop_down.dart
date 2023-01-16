import 'package:formz/formz.dart';

enum AddGroupCategoryBottomSheetError { EmptyName }

class AddGroupCategoryBottomSheet extends FormzInput<String, AddGroupCategoryBottomSheetError> {
  const AddGroupCategoryBottomSheet.pure() : super.pure('');
  const AddGroupCategoryBottomSheet.dirty([String value = '']) : super.dirty(value);
  @override
  AddGroupCategoryBottomSheetError validator(String value) {
    return value?.isNotEmpty == true? null : AddGroupCategoryBottomSheetError.EmptyName;
  }
}
