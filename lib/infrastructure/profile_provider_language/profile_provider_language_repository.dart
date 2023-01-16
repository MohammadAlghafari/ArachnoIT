import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/call/delete_language.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/call/get_profile_language.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/call/set_new_language.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/profile_provider_language_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/response/language_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class ProfileProvierLanguageRepository
    implements ProfileProviderLanguageInterface {
  GetProfileLanguage getProfileLanguage;
  SetNewLanguage setNewLanguage;
  DeleteLanguage deleteLanguage;
  ProfileProvierLanguageRepository({
    @required this.getProfileLanguage,
    @required this.setNewLanguage,
    @required this.deleteLanguage,
  });
  @override
  Future<ResponseWrapper<List<LanguageResponse>>> getAllLanguage({
    String searchString,
    int pageNumber,
    int pageSize,
    bool enablePagination = true,
    String healthcareProviderId,
  }) async {
    try {
      Response response = await getProfileLanguage.getProviderProfileLanguage(
          pageNumber: pageNumber,
          pageSize: pageSize,
          searchString: searchString,
          enablePagination: enablePagination,
          healthcareProviderId: healthcareProviderId);
      return _prepareGetProviderProfileLanguage(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetProviderProfileLanguage(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetProviderProfileLanguage(remoteResponse: null);
    }
  }

  ResponseWrapper<List<LanguageResponse>> _prepareGetProviderProfileLanguage(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<LanguageResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => LanguageResponse.fromJson(x))
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
  Future<ResponseWrapper<bool>> addNewLanguage({
    int languageLevel,
    String languageId,
  }) async {
    try {
      Response response = await setNewLanguage.addNewLanguage(
          languageId: languageId, languageLevel: languageLevel);
      return _preparAddNewLanguage(remoteResponse: response);
    } on DioError catch (e) {
      return _preparAddNewLanguage(remoteResponse: e.response);
    } catch (e) {
      return _preparAddNewLanguage(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparAddNewLanguage(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      res.data = false;
      if (remoteResponse.statusCode == 200) res.data = true;
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

  @override
  Future<ResponseWrapper<bool>> deleteSelectedItem({
    String itemId,
  }) async {
    try {
      Response response = await deleteLanguage.deleteLanguage(itemId: itemId);
      return _preparDeleteSelectedItem(remoteResponse: response);
    } on DioError catch (e) {
      return _preparDeleteSelectedItem(remoteResponse: e.response);
    } catch (e) {
      return _preparDeleteSelectedItem(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparDeleteSelectedItem(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      res.data = false;
      if (remoteResponse.statusCode == 200) res.data = true;
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
