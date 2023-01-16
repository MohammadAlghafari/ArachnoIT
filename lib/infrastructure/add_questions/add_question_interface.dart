import 'package:arachnoit/infrastructure/add_questions/response/add_question_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:flutter/material.dart';

abstract class AddQuestionInterface {
  Future<ResponseWrapper<AddQuestionResponse>> addQuestion({
    @required String id,
    @required List<String> subCategoryIds,
    @required String groupId,
    @required String title,
    @required String body,
    @required bool viewToHealthcareProvidersOnly,
    @required bool askAnonymously,
    @required List<String> questionTags,
    @required List<FileResponse> files,
  });

  Future<dynamic> getAllTags();

  Future<dynamic> getCategories();

  Future<dynamic> getSubCategories({
    @required String categoryId,
  });
}
