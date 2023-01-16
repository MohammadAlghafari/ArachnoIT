import 'package:arachnoit/infrastructure/api/response_wrapper.dart';

abstract class LanguageInterface {
  Future<ResponseWrapper<bool>> setLanguage();
}
