








import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_permission/response/group_permission_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'caller/group_perimsiion_remote_data_provider.dart';

class GetGroupPermissionRepository  {
  final GetGroupPermissionsRemoteDataProvider getGroupPermissionsRemoteDataProvider;

  GetGroupPermissionRepository({@required this.getGroupPermissionsRemoteDataProvider});

  @override
  Future<ResponseWrapper<List<GroupPermission>>> getGroupPermission() async {
    try {
      Response response = await getGroupPermissionsRemoteDataProvider.getGroupPermission();
      return _prepareGroupPermissionResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGroupPermissionResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGroupPermissionResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<GroupPermission>> _prepareGroupPermissionResponse({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GroupPermission>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List).map((x) => GroupPermission.fromJson(x)).toList();
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
