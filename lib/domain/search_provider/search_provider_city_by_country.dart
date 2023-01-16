import 'package:formz/formz.dart';

enum SearchProviderCityByProviderError { EmptyName }

class SearchProviderCityByProvider
    extends FormzInput<String, SearchProviderCityByProviderError> {
  const SearchProviderCityByProvider.pure() : super.pure('');
  const SearchProviderCityByProvider.dirty([String value = ''])
      : super.dirty(value);
  @override
  SearchProviderCityByProviderError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : SearchProviderCityByProviderError.EmptyName;
  }
}
