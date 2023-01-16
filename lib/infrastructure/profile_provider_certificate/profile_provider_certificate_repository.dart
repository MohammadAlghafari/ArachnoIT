import 'dart:io';
import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/call/delete_certificate.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/call/set_new_certificate.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/call/update_certificate.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/profile_provider_certificate_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/repository/certificate_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import 'call/get_profile_certificate.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/repository/new_certificate_response.dart';

class ProfileProviderCertificateRepository
    implements ProfileProviderCertificateInterface {
  GetProfileCertificate getProfileCertificate;
  SetNewCertificate setNewCertificate;
  UpdateCertificate updateCertificate;
  DeleteCertificate deleteCertificate;
  ProfileProviderCertificateRepository({
    @required this.getProfileCertificate,
    @required this.setNewCertificate,
    @required this.updateCertificate,
    @required this.deleteCertificate,
  });
  @override
  Future<ResponseWrapper<List<CertificateResponse>>> getUserProfileCertificate({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response =
          await getProfileCertificate.getProviderProfileCertificate(
              pageNumber: pageNumber,
              pageSize: pageSize,
              healthcareProviderId: healthcareProviderId,
              searchString: searchString);
      return _prepareGetUserProfileCertificate(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetUserProfileCertificate(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetUserProfileCertificate(remoteResponse: null);
    }
  }

  ResponseWrapper<List<CertificateResponse>> _prepareGetUserProfileCertificate(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CertificateResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => CertificateResponse.fromJson(x))
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
  Future<ResponseWrapper<NewCertificateResponse>> addNewCertificate({
    String name,
    String issueDate,
    String expirationDate,
    String organization,
    String url,
    File file,
  }) async {
    try {
      Response response = await setNewCertificate.addNewCertificate(
        expirationDate: expirationDate,
        file: file,
        issueDate: issueDate,
        name: name,
        organization: organization,
        url: url,
      );
      return _preparAaddNewCertificate(remoteResponse: response);
    } on DioError catch (e) {
      return _preparAaddNewCertificate(remoteResponse: e.response);
    } catch (e) {
      return _preparAaddNewCertificate(remoteResponse: null);
    }
  }

  ResponseWrapper<NewCertificateResponse> _preparAaddNewCertificate(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewCertificateResponse>();
    if (remoteResponse != null) {
      res.data =
          NewCertificateResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<NewCertificateResponse>> updateSelectedCertificate({
    String name,
    String issueDate,
    String expirationDate,
    String organization,
    String url,
    File file,
    String id,
    List<String> removedfiles,
  }) async {
    try {
      Response response = await updateCertificate.updateCertificate(
          expirationDate: expirationDate,
          file: file,
          issueDate: issueDate,
          name: name,
          organization: organization,
          url: url,
          id: id,
          removedfiles: removedfiles);
      return _preparAaddNewCertificate(remoteResponse: response);
    } on DioError catch (e) {
      return _preparAaddNewCertificate(remoteResponse: e.response);
    } catch (e) {
      return _preparAaddNewCertificate(remoteResponse: null);
    }
  }

  @override
  Future<ResponseWrapper<bool>> deleteSelectedCertificate({
    String itemId,
  }) async {
    try {
      Response response =
          await deleteCertificate.deleteCertificate(itemId: itemId);
      return _preparDeleteSelectedCertificate(remoteResponse: response);
    } on DioError catch (e) {
      print("the erros is $e");
      return _preparDeleteSelectedCertificate(remoteResponse: e.response);
    } catch (e) {
      print("the erros is $e");
      return _preparDeleteSelectedCertificate(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparDeleteSelectedCertificate(
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
