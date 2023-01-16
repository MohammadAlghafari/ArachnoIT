import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/response/language_response.dart';

abstract class ProfileProviderLanguageInterface {
  Future<ResponseWrapper<List<LanguageResponse>>> getAllLanguage({
    String searchString,
    int pageNumber,
    int pageSize,
    bool enablePagination,
    String healthcareProviderId,
  });

  Future<ResponseWrapper<bool>> addNewLanguage({
    int languageLevel,
    String languageId,
  });

  Future<ResponseWrapper<bool>> deleteSelectedItem({
    String itemId,
  });

}
