import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UpdateCertificate {
  final Dio dio;
  UpdateCertificate({@required this.dio});
  Future<dynamic> updateCertificate({
    String name,
    String issueDate,
    String expirationDate,
    String organization,
    String url,
    File file,
    String id,
    List<String>removedfiles
  }) async {
    Map<String, dynamic> _map = {
      "Name": name,
      "IssueDate": issueDate,
      "Organization": organization,
      "Url": url,
      "Id": id,
      "removedfiles":removedfiles
    };
    if(expirationDate==null){
      _map["ExpirationDate"]= expirationDate;
    }
    print("the map value is $_map");
    if (file != null) {
      String fileName = file.path.split('/').last;
      _map["Attachments"] =
          await MultipartFile.fromFile(file.path, filename: fileName);
    }
    FormData _formData = FormData.fromMap(_map);
    Response response = await dio.post(Urls.ADD_CERTIFICATE, data: _formData);
    return response;
  }
}
