import 'dart:io';

import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/call/get_profile_licenses.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/call/set_new_license.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/call/update_license.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/call/delete_licenses.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/profile_provider_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/licenses_response.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import 'response/new_license_response.dart';

class ProfileProviderRepository implements ProfileProviderInterface {
  final GetProfileLicenses getProfileLicenses;
  final SetNewLicense setNewLicense;
  final UpadteLicense upadteLicense;
  final DeleteLicenses deleteLicenses;
  ProfileProviderRepository({
    @required this.getProfileLicenses,
    @required this.setNewLicense,
    @required this.upadteLicense,
    @required this.deleteLicenses,
  });

  @override
  Future<ResponseWrapper<List<LicensesResponse>>> getUserProfileLicenses({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response = await getProfileLicenses.getProviderProfileLicenses(
          pageNumber: pageNumber,
          pageSize: pageSize,
          healthcareProviderId: healthcareProviderId,
          searchString: searchString);
      return _prepareGetProviderProfileLicenses(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetProviderProfileLicenses(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetProviderProfileLicenses(remoteResponse: null);
    }
  }

  ResponseWrapper<List<LicensesResponse>> _prepareGetProviderProfileLicenses(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<LicensesResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => LicensesResponse.fromJson(x))
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
  Future<ResponseWrapper<NewLicenseResponse>> addNewLicense(
      {String title, String description, File file}) async {
    try {
      Response response = await setNewLicense.addNewLicense(
          description: description, file: file, title: title);
      return _prepareSetNewLicense(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSetNewLicense(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareSetNewLicense(remoteResponse: null);
    }
  }

  ResponseWrapper<NewLicenseResponse> _prepareSetNewLicense(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewLicenseResponse>();
    if (remoteResponse != null) {
      res.data =
          NewLicenseResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<NewLicenseResponse>> updateSelectedLicense(
      {String title, String description, File file, String id}) async {
    try {
      Response response = await upadteLicense.upadteSelectedLicense(
        description: description,
        file: file,
        title: title,
        id: id,
      );
      return _prepareSetNewLicense(remoteResponse: response);
    } on DioError catch (e) {
      print("the error is $e");
      return _prepareSetNewLicense(remoteResponse: e.response);
    } catch (e) {
      print("the error is $e");
      return _prepareSetNewLicense(remoteResponse: null);
    }
  }

  @override
  Future<ResponseWrapper<bool>> deleteSelectedLicenses({
    String itemId,
  }) async {
    try {
      print("the current is 2");

      Response response = await deleteLicenses.deleteExperiance(itemId: itemId);
      print("the current is 3");

      return _preparDeleteSelectedLicense(remoteResponse: response);
    } on DioError catch (e) {
      print("the erros is $e");
      return _preparDeleteSelectedLicense(remoteResponse: e.response);
    } catch (e) {
      print("the erros is $e");
      return _preparDeleteSelectedLicense(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparDeleteSelectedLicense(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
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
