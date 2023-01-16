import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/discover_categories_sub_category_all_blogs/caller/get_sub_category_all_blogs_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/discover_categories_sub_category_all_blogs/discover_categories_sub_category_all_blogs_interface.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../api/response_type.dart' as ResType;

class DiscoverCategoriesSubCategoryAllBlogsRepository
    implements DiscoverCategoriesSubCategoryAllBlogsInterface {
  DiscoverCategoriesSubCategoryAllBlogsRepository(
      {this.getSubCategoryAllBlogsRemoteDataProvider});
  final GetSubCategoryAllBlogsRemoteDataProvider
      getSubCategoryAllBlogsRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getSubCategoryBlogs(
      {String subCategoryId, int pageNumber, int pageSize}) async {
    try {
      Response response =
          await getSubCategoryAllBlogsRemoteDataProvider.getSubCategoryAllBlogs(
        subCategoryId: subCategoryId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareBlogsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareBlogsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareBlogsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<GetBlogsResponse>> _prepareBlogsResponse(
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
