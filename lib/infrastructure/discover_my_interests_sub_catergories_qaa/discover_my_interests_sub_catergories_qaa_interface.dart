import '../api/response_wrapper.dart';
import '../home_qaa/response/qaa_response.dart';
import 'package:flutter/cupertino.dart';

abstract class DiscoverMyInterestsSubCatergoriesQaaInterface {
  Future<ResponseWrapper<List<QaaResponse>>> getInterestsSubCategoriesQaaRemote({
    @required int pageNumber,
    @required int pageSize,
    @required String subCategoryId,
  });
}
