import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';

abstract class DiscoverMyInterestsAddInterestsInterface{
  Future<ResponseWrapper<List<CategoryResponse>>> getInterestsAtInterestsRemote();
}