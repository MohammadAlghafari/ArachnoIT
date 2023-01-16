import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UpdateEducations {
  final Dio dio;
  UpdateEducations({@required this.dio});
  Future<dynamic> updateEducation({
    String grade,
    String school,
    String link,
    String startDate,
    String endDate,
    String fieldOfStudy,
    String description,
    List<ImageType> file,
    List<String> removedFiles,
    String id,
  }) async {
    List multipartArray = [];
    for (ImageType item in file) {
      if (item.isFromDataBase == false) {
        String fileName = item.fileFromDevice.path.split('/').last;
        multipartArray.add(
          await MultipartFile.fromFile(item.fileFromDevice.path,
              filename: fileName),
        );
      }
    }
    FormData _formData = FormData.fromMap({
      "Attachments": multipartArray,
      "Grade": grade,
      "School": school,
      "StartDate": startDate,
      "EndDate": endDate,
      "FieldOfStudy": fieldOfStudy,
      "Description": description,
      "Link": link,
      "Id": id,
      "removedfiles": removedFiles
    });
    Response response = await dio.post(Urls.ADD_EDUCATION, data: _formData);
    return response;
  }
}
