import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetCourse {
  final Dio dio;
  SetCourse({@required this.dio});
  Future<dynamic> setCourse({
    String name,
    String place,
    String date,
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
      "Name": name,
      "Date": date,
      "Place": place,
    });
    Response response = await dio.post(Urls.Set_Course, data: _formData);
    return response;
  }
}
