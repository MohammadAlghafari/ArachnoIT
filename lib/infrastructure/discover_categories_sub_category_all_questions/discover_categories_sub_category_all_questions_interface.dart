import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:flutter/material.dart';

abstract class DiscoverCategoriesSubCategoryAllQuestionsInterface{
  Future<ResponseWrapper<List<QaaResponse>>> getSubCategoryAllQuestions({
    @required String categoryId,
    @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  });
}