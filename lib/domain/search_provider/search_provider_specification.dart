import 'package:formz/formz.dart';

enum SearchProviderSpecificationError { EmptyName }

class SearchProviderSpecification
    extends FormzInput<String, SearchProviderSpecificationError> {
  const SearchProviderSpecification.pure() : super.pure('');
  const SearchProviderSpecification.dirty([String value = ''])
      : super.dirty(value);
  @override
  SearchProviderSpecificationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : SearchProviderSpecificationError.EmptyName;
  }
}
