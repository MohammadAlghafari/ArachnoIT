import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';

abstract class DiscoverCategoriesInterface {
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories();
}
