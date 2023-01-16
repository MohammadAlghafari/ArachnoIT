import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/discover_my_interests_add_interests/caller/get_my_interests_at_interests_remote.dart';
import 'package:arachnoit/infrastructure/discover_my_interests_add_interests/discover_my_interests_add_interests_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class DiscoverMyInterestsAddInterestsRepository
    implements DiscoverMyInterestsAddInterestsInterface {
  final GetMyInterestsAddInterestsRemote getMyInterestsAtInterestsRemote;
  DiscoverMyInterestsAddInterestsRepository(
      {@required this.getMyInterestsAtInterestsRemote});
  @override
  Future<ResponseWrapper<List<CategoryResponse>>>
      getInterestsAtInterestsRemote() async {
    try {
      Response response =await getMyInterestsAtInterestsRemote.getInterestsAtInterestsRemote();
      return _prepareInterestAtInterestResponse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareInterestAtInterestResponse(
        remoteResponse: e.response,
      );
    } catch (r) {
      return null;
    }
  }

  ResponseWrapper<List<CategoryResponse>> _prepareInterestAtInterestResponse(
      {@required Response<dynamic> remoteResponse}) {
    final res = ResponseWrapper<List<CategoryResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => CategoryResponse.fromMap(x))
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
