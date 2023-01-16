import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';

abstract class DiscoverMyInterests {
  Future<ResponseWrapper<List<CategoryResponse>>> getInterestSubCategories();
  Future<ResponseWrapper<bool>> actionSubscrption(List<dynamic>listOfParam);
}
