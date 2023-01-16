import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetProject {
  final Dio dio;
  SetProject({@required this.dio});
  Future<dynamic> setProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
    String description,
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
      "Name": name,
      "StartDate": startDate,
      "EndDate": endDate,
      "Link": link,
      "Attachments": multipartArray,
      "Description": description
    });
    Response response = await dio.post(Urls.SET_PROJECT, data: _formData);
    return response;
  }
}
