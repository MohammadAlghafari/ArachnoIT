import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UpadteLicense {
  final Dio dio;
  UpadteLicense({@required this.dio});
  Future<dynamic> upadteSelectedLicense({
    @required String title,
    @required String description,
    @required File file,
    @required String id,
  }) async {
    Map<String, dynamic> _map = {
      "Title": title,
      "Description": description,
      "Id": id
    };
    if (file != null) {
      String fileName = file.path.split('/').last;
      _map["file"] = await MultipartFile.fromFile(file.path, filename: fileName);
    }
    FormData formData = FormData.fromMap(_map);
    Response response = await dio.post(Urls.ADD_LICENSES, data: formData);
    return response;
  }
}