import 'package:arachnoit/infrastructure/add_blog/response/add_blog_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:flutter/material.dart';

abstract class AddBlogInterface {
  Future<ResponseWrapper<AddBlogResponse>> addBlog({
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
  });

  Future<dynamic> getAllTags();

  Future<dynamic> getCategories();

  Future<dynamic> getSubCategories({
    @required String categoryId,
  });
}
