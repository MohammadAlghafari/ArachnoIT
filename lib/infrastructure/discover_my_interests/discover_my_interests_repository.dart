import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/discover_my_interests/caller/action_subscrption_remote.dart';

import '../common_response/category_response.dart';
import '../api/response_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import 'caller/get_my_interests_sub_catergories_remote.dart';
import 'discover_my_interests_interface.dart';

class DiscoverMyInterestsRepository implements DiscoverMyInterests {
  DiscoverMyInterestsRepository({
    @required this.getMyInterestSubCategories,
    @required this.getSubScriptionRemote,
  });
  GetMyInterestsSubCategoriesRemote getMyInterestSubCategories;
  GetSubScriptionRemote getSubScriptionRemote;
  @override
  Future<ResponseWrapper<List<CategoryResponse>>>
      getInterestSubCategories() async {
    try {
      Response response = await getMyInterestSubCategories.getSubCategories();
      return _prepareInterestSubCategoriesResponse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareInterestSubCategoriesResponse(
        remoteResponse: e.response,
      );
    } catch (r) {
      return null;
    }
  }

  ResponseWrapper<List<CategoryResponse>> _prepareInterestSubCategoriesResponse(
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

  @override
  Future<ResponseWrapper<bool>> actionSubscrption(
      List<dynamic> listOfParam) async {
    try {
      Response response =
          await getSubScriptionRemote.getSubCategories(listOfParam);
      return _prepareActionSubscrption(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareActionSubscrption(remoteResponse: e.response.data);
    } catch (e) {
      _prepareActionSubscrption(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareActionSubscrption(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
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
