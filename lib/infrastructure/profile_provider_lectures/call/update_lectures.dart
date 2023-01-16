import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UpdateLectures {
  final Dio dio;
  UpdateLectures({@required this.dio});
  Future<dynamic> updateLectures({
    String title,
    String description,
    List<ImageType> file,
    String itemId,
    List<String>removedFile,
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
      "Attachments": multipartArray,
      "Description": description,
      "Title": title,
      "Id": itemId,
      "removedFile":removedFile,
    });
    print("The param is $title and $description and $itemId , and ");
    Response response = await dio.post(Urls.SET_LECTURES, data: _formData);
    return response;
  }
}
