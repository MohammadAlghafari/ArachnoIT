import 'package:formz/formz.dart';

enum FilesValidationErrors { EmptyName }

class FilesValidation extends FormzInput<String, FilesValidationErrors> {
  const FilesValidation.pure() : super.pure('');
  const FilesValidation.dirty([String value = '']) : super.dirty(value);
  @override
  FilesValidationErrors validator(String value) {
    return value?.isNotEmpty == true ? null : FilesValidationErrors.EmptyName;
  }
}
