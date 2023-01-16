import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;
import 'package:arachnoit/infrastructure/profile_action/caller/profile_action_remote_data_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileActionRepository {
  ProfileActionRemoteDataProvider profileActionRemoteDataProvider;

  ProfileActionRepository({
    @required this.profileActionRemoteDataProvider,
  });

  Future<ResponseWrapper<bool>> setFollowProvider({
    @required String healthCareProviderId,
    @required bool followStatus
  }) async {
    try {
      Response response = await profileActionRemoteDataProvider.setFollow(followStatus: followStatus, healthCareProviderId: healthCareProviderId);
      return _prepareSetFollowProfile(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSetFollowProfile(remoteResponse: e.response);
    } catch (e) {
      return _prepareSetFollowProfile(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareSetFollowProfile({@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      res.data = false;
      if (remoteResponse.statusCode == 200) res.data = true;
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage = remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName = remoteResponse.data[AppConst.OPERATON_NAME] as String;

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
