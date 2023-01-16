
import 'caller/get_my_interests_sub_categories_blogs.dart';

import '../api/response_wrapper.dart';
import 'discover_my_interests_sub_categories_blogs_interface.dart';
import '../home_blog/response/get_blogs_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class DisconverMyInterestsSubCategorisRepositories implements DiscoverMyInterestsSubCategoriesBlogsInterface {
  GetMyInterestsSubCategoriesBlogsRemote getMyInterestsSubCategories;
  DisconverMyInterestsSubCategorisRepositories(
      {@required this.getMyInterestsSubCategories});
  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoriesBlogs(
      {String subCategoryId, int pageNumber, int pageSize}) async {
    try {
      Response responseWrapper =
          await getMyInterestsSubCategories.getSubCategoriesBlogs(
              pageNumber: pageNumber,
              pageSize: pageSize,
              subCategoryId: subCategoryId);
      ResponseWrapper<List<GetBlogsResponse>> items =
          _prepareGetBlogsResponse(remoteResponse: responseWrapper);
      return items;
    } on DioError catch (e) {
      print("the error is $e");

      return _prepareGetBlogsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      print("the error is $e");
      return null;
    }
  }

  ResponseWrapper<List<GetBlogsResponse>> _prepareGetBlogsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GetBlogsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => GetBlogsResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
