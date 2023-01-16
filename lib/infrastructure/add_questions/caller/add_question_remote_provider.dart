import 'dart:convert';

import 'package:arachnoit/infrastructure/add_questions/response/add_question_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddQuestionRemoteDataToServer {
  AddQuestionRemoteDataToServer({@required this.dio});

  final Dio dio;

  Future<dynamic> addQuestion({
    @required String id,
    @required List<String> subCategoryIds,
    @required String groupId,
    @required String title,
    @required String body,
    @required bool viewToHealthcareProvidersOnly,
    @required bool askAnonymously,
    @required List<String> questionTags,
    @required List<FileResponse> files,
    @required List<String> removedFiles,
  }) async {
    List multipartArray = [];
    for (var i = 0; i < files.length; i++) {
      multipartArray.add(
        MultipartFile.fromFileSync(
          files[i].url,
          filename: files[i].name,
        ),
      );
    }
    FormData formData = FormData.fromMap({
      'Id': id,
      'SubCategoryIds': jsonEncode(subCategoryIds) ,
      'GroupId': groupId,
      'title': title,
      'body': body,
      'ViewToHealthcareProvidersOnly': viewToHealthcareProvidersOnly,
      'AskAnonymously': askAnonymously,
      'QuestionTags': questionTags,
      'files': multipartArray,
      'removedFiles': removedFiles,
    });
    Response response = await dio.post(Urls.ADD_QUESTION, data: formData);
    return response;
  }
}
