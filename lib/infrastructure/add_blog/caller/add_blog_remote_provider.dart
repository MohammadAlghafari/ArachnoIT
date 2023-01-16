import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBlogRemoteDataToServer {
  AddBlogRemoteDataToServer({@required this.dio});

  final Dio dio;

  Future<dynamic> addBlog({
    @required String id,
    @required String subCategoryId,
    @required String groupId,
    @required String title,
    @required String body,
    @required int blogType,
    @required bool viewToHealthcareProvidersOnly,
    @required bool publishByCreator,
    @required List<String> blogTags,
    @required List<FileResponse> files,
    @required String externalFileUrl,
    @required int externalFileType,
    @required List<String> removedFiles,
  }) async {
    List multipartArray = [];

    if (files != null) {
      for (var i = 0; i < files.length; i++) {
        multipartArray.add(
          MultipartFile.fromFileSync(
            files[i].url,
            filename: files[i].name,
          ),
        );
      }
    }
    print("the files is $files");
    FormData formData = FormData.fromMap({
      'Id': id,
      'SubCategoryId': subCategoryId,
      'GroupId': groupId,
      'Title': title,
      'Body': body,
      'BlogType': blogType,
      'ViewToHealthcareProvidersOnly': viewToHealthcareProvidersOnly,
      'PublishbyCreator': publishByCreator,
      'BlogTags': blogTags,
      'files': multipartArray != null ? multipartArray : null,
      'ExternalFileUrl': externalFileUrl.isEmpty ? null : externalFileUrl,
      'ExternalFileType': externalFileType,
      'removedFiles': removedFiles,
    });
    Response response = await dio.post(Urls.ADD_BLOG, data: formData);
    return response;
  }
}
