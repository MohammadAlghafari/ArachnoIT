import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetNewEducation {
  final Dio dio;
  SetNewEducation({@required this.dio});
  Future<dynamic> addNewEducation({
    String grade,
    String school,
    String link,
    String startDate,
    String endDate,
    String fieldOfStudy,
    String description,
    List<ImageType> file,
  }) async {
    List multipartArray = [];
    for (ImageType item in file) {
      String fileName = item.fileFromDevice.path.split('/').last;
      multipartArray.add(
        await MultipartFile.fromFile(item.fileFromDevice.path,
            filename: fileName),
      );
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
    });
    Response response = await dio.post(Urls.ADD_EDUCATION, data: _formData);
    return response;
  }
}
