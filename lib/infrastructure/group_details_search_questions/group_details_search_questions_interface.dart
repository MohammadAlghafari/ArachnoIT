import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:flutter/material.dart';

abstract class GroupDetailsSearchQuestionsInterface {
  Future<ResponseWrapper<List<QaaResponse>>> getSearchTextQuestions({
    @required String groupId,
    @required String query,
    @required int pageNumber,
    @required int pageSize,
  });

  Future<ResponseWrapper<List<QaaResponse>>> getAdvancedSearchQuestions({
    @required int accountTypeId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required List<String> tagsId,
    @required int pageNumber,
    @required int pageSize,
  });
}
