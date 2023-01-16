import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UpdateProject {
  final Dio dio;
  UpdateProject({@required this.dio});
  Future<dynamic> updateProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
    String description,
    String id,
    List<String> removedfiles,
  }) async {
    List multipartArray = [];
    for (ImageType item in file) {
      if (item.isFromDataBase) continue;
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
      "Description": description,
      "Id": id,
      "removedfiles": removedfiles
    });
    Response response = await dio.post(Urls.SET_PROJECT, data: _formData);
    return response;
  }
}
