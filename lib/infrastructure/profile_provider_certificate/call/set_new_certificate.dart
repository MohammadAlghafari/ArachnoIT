import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetNewCertificate {
  final Dio dio;
  SetNewCertificate({@required this.dio});
  Future<dynamic> addNewCertificate({
    String name,
    String issueDate,
    String expirationDate,
    String organization,
    String url,
    File file,
  }) async {
    String fileName = file.path.split('/').last;
    FormData _formData = FormData.fromMap({
      "Attachments":
          await MultipartFile.fromFile(file.path, filename: fileName),
      "Name": name,
      "IssueDate": issueDate,
      "ExpirationDate": expirationDate,
      "Organization": organization,
      "Url": url,
    });
    Response response = await dio.post(Urls.ADD_CERTIFICATE, data: _formData);
    return response;
  }
}
