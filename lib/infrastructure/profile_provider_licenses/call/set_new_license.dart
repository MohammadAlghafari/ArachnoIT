import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetNewLicense {
  final Dio dio;
  SetNewLicense({@required this.dio});
  Future<dynamic> addNewLicense(
      {String title, String description, File file}) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
      "Title": title,
      "Description": description,
    });
    Response response = await dio.post(Urls.ADD_LICENSES, data: formData);
    return response;
  }
}
