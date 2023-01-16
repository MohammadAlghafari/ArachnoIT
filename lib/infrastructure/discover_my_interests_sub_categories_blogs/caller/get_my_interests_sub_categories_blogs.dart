import '../../api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetMyInterestsSubCategoriesBlogsRemote {
  Dio dio;
  GetMyInterestsSubCategoriesBlogsRemote({@required this.dio});
  Future<dynamic> getSubCategoriesBlogs({
   @required String subCategoryId,
    @required int pageNumber,
    @required int pageSize,
  }) async {
    final params = {
      // 'personId': personId ?? "",
      // 'accountTypeId': accountTypeId ?? "",
      // 'blogId': blogId ?? "",
      // 'categoryId': categoryId ?? "",
      'subCategoryId': subCategoryId ?? "",
      // 'groupId': groupId ?? "",
      // 'myFeed': myFeed ?? "",
      // 'tagsId': tagsId ?? "",
      // 'query': query ?? "",
      // 'isResearcher': isResearcher ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
      // 'orderByBlogs': orderByBlogs ?? "",
      // 'mySubscriptionsOnly': mySubscriptionsOnly ?? ""
    };
    Response response = await dio.get(Urls.GET_BLOGS, queryParameters: params);
    return response;
  }
}
