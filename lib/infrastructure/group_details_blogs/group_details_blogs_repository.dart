import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../home_blog/response/get_blogs_response.dart';
import 'caller/get_groups_blog_remote_data_provider.dart';
import 'group_details_blogs_interface.dart';

class GroupDetailsBlogsRepository implements GroupDetailsBlogsInterface {
  GroupDetailsBlogsRepository({this.getGroupBlogsRemoteDataProvider});

  final GetGroupBlogsRemoteDataProvider getGroupBlogsRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getGroupBlogs(
      {String groupId, int pageNumber, int pageSize}) async {
    try {
      Response response = await getGroupBlogsRemoteDataProvider.getGroupBlogs(
        groupId: groupId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareGroupBlogsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGroupBlogsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGroupBlogsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<GetBlogsResponse>> _prepareGroupBlogsResponse(
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
