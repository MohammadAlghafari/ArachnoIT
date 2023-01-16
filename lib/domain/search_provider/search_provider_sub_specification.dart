import 'package:formz/formz.dart';

enum SearchProviderSubSpecificationError { EmptyName }

class SearchProviderSubSpecification
    extends FormzInput<String, SearchProviderSubSpecificationError> {
  const SearchProviderSubSpecification.pure() : super.pure('');
  const SearchProviderSubSpecification.dirty([String value = ''])
      : super.dirty(value);
  @override
  SearchProviderSubSpecificationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : SearchProviderSubSpecificationError.EmptyName;
  }
}
