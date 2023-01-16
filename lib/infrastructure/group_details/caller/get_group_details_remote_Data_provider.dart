import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetGroupDetailsRemoteDataProvider {
  GetGroupDetailsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getGroupDetails({
    @required String groupId,
  }) async {
    final params = {
      'id': groupId,
    };
    Response response = await dio.get(Urls.GET_GROUP_DETAILS, queryParameters: params);
    return response;
  }

  Future<dynamic> deleteGroup({@required String groupId}) async {
    final param = {"itemId": groupId};
    Response response = await dio.delete(Urls.Delete_Group, data: param);
    return response;
  }
}
