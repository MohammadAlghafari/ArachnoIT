import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AddNewLectures {
  final Dio dio;
  AddNewLectures({@required this.dio});
  Future<dynamic> addNewLectures({
    String title,
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
      "Description": description,
      "Title": title,
    });
    Response response = await dio.post(Urls.SET_LECTURES, data: _formData);
    return response;
  }
}
