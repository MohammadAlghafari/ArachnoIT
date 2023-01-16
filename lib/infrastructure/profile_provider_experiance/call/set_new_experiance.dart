import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetNewExperiance {
  final Dio dio;
  SetNewExperiance({@required this.dio});
  Future<dynamic> addNewExperiance({
    String name,
    String startDate,
    String endDate,
    String organization,
    String url,
    List<ImageType> file,
    String description,
  }) async {
    List multipartArray = [];
    for (ImageType item in file) {
      String fileName = item.fileFromDevice.path.split('/').last;
      multipartArray.add(
        await MultipartFile.fromFile(item.fileFromDevice.path, filename: fileName),
      );
    }
    FormData _formData = FormData.fromMap({
      "Attachments": multipartArray,
      "Link": url,
      "Description": description,
      "StartDate": startDate,
      "EndDate": endDate,
      "Company": organization,
      "Title": name,
    });
    Response response = await dio.post(Urls.ADD_EXPERIANCE, data: _formData);
    return response;
  }
}
