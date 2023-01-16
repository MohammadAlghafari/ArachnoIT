import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetProfileImage {
  final Dio dio;
  SetProfileImage({@required this.dio});
  Future<dynamic> setImage({
    File imagePath,
    bool removeFile,
  }) async {
    Map<String, dynamic> _map = {};
    _map["RemoveFile"] = removeFile;
    if (removeFile) {
    } else {
      String fileNamee = imagePath.path.split('/').last;
      _map["FileDto"] =
          await MultipartFile.fromFile(imagePath.path, filename: fileNamee);
    }
    FormData _formData = FormData.fromMap(_map);
    Response response = await dio.put(Urls.SET_PROFILE_PHOTOS, data: _formData);
    return response;
  }
}
