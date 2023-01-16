import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddAnswer {
  AddAnswer({@required this.dio});

  final Dio dio;

  Future<dynamic> actionAnswer({
    @required String id,
    @required String questionId,
    @required String body,
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
      'QuestionId': questionId,
      'Body': body,
      'Files': multipartArray,
      'RemovedFiles': removedFiles,
    });
    Response response = await dio.post(Urls.ADD_ANSWER, data: formData);
    return response;
  }
}
