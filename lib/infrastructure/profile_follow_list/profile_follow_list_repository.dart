import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/call/get_profile_follow_list_info.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/profile_follow_list_interface.dart';
import 'package:arachnoit/infrastructure/profile_follow_list/response/profile_follow_list_reponse.dart';
import 'package:dio/dio.dart';
import '../api/response_type.dart' as ResType;
import 'package:flutter/material.dart';

class ProfileFollowListRepository implements ProfileFollowListInterface {
  final GetProfileFollowListInfo getProfileFollowInfo;

  ProfileFollowListRepository({
    this.getProfileFollowInfo,
  });

  @override
  Future<ResponseWrapper<ProfileFollowListResponse>> getProfileFollowListInfo({
    String healthcareProviderId,
  }) async {
    try {
      Response response = await getProfileFollowInfo.getProfileFollowListInfo(
          healthcareProviderId: healthcareProviderId);
      return _prepareGetProfileFollowInfo(remoteResponse: response);
    } on DioError catch (e) {
      print("the error  is Dio$e");

      return _prepareGetProfileFollowInfo(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareGetProfileFollowInfo(remoteResponse: null);
    }
  }

  ResponseWrapper<ProfileFollowListResponse> _prepareGetProfileFollowInfo(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<ProfileFollowListResponse>();
    if (remoteResponse != null) {
      res.data = ProfileFollowListResponse.fromJson(remoteResponse.data);
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
