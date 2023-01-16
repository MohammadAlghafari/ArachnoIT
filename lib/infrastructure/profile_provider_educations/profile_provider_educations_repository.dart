import 'dart:io';

import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/call/delete_education.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/call/get_profile_educatios.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/call/set_new_education.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/call/update_educations.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/profile_provider_educations_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/response/educations_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/response/new_education_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../api/response_type.dart' as ResType;

class ProfileProviderEducationsRepository
    implements ProfileProviderEducationsInterface {
  GetProfileEducations getProfileEducations;
  SetNewEducation setNewEducation;
  UpdateEducations updateEducations;
  DeleteEducation deleteEducation;
  ProfileProviderEducationsRepository({
    @required this.getProfileEducations,
    @required this.setNewEducation,
    @required this.updateEducations,
    @required this.deleteEducation,
  });
  @override
  Future<ResponseWrapper<List<EducationsResponse>>> getUserProfileEducation({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response =
          await getProfileEducations.getProviderProfileEducations(
              pageNumber: pageNumber,
              pageSize: pageSize,
              healthcareProviderId: healthcareProviderId,
              searchString: searchString);
      return _prepareGetUserProfileEducation(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetUserProfileEducation(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetUserProfileEducation(remoteResponse: null);
    }
  }

  ResponseWrapper<List<EducationsResponse>> _prepareGetUserProfileEducation(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<EducationsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => EducationsResponse.fromJson(x))
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
  Future<ResponseWrapper<NewEducationResponse>> addNewEducation({
    String grade,
    String school,
    String link,
    String startDate,
    String endDate,
    String fieldOfStudy,
    String description,
    List<ImageType> file,
  }) async {
    try {
      Response response = await setNewEducation.addNewEducation(
        description: description,
        endDate: endDate,
        fieldOfStudy: fieldOfStudy,
        file: file,
        grade: grade,
        link: link,
        school: school,
        startDate: startDate,
      );
      return _preparAddNewEducation(remoteResponse: response);
    } on DioError catch (e) {
      return _preparAddNewEducation(remoteResponse: e.response);
    } catch (e) {
      return _preparAddNewEducation(remoteResponse: null);
    }
  }

  ResponseWrapper<NewEducationResponse> _preparAddNewEducation(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewEducationResponse>();
    if (remoteResponse != null) {
      res.data =
          NewEducationResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<NewEducationResponse>> updateSelectedEducations({
    String grade,
    String school,
    String link,
    String startDate,
    String endDate,
    String fieldOfStudy,
    String description,
    List<ImageType> file,
    String id,
    List<String> removedFiles,
  }) async {
    try {
      Response response = await updateEducations.updateEducation(
        description: description,
        endDate: endDate,
        fieldOfStudy: fieldOfStudy,
        file: file,
        grade: grade,
        link: link,
        school: school,
        startDate: startDate,
        id: id,
        removedFiles: removedFiles,
      );
      return _preparAddNewEducation(remoteResponse: response);
    } on DioError catch (e) {
      return _preparAddNewEducation(remoteResponse: e.response);
    } catch (e) {
      return _preparAddNewEducation(remoteResponse: null);
    }
  }

  @override
  Future<ResponseWrapper<bool>> deleteSelectedEducation({
    String itemId,
  }) async {
    try {
      Response response = await deleteEducation.deleteEducation(itemId: itemId);
      return _preparDeleteSelectedCertificate(remoteResponse: response);
    } on DioError catch (e) {
      return _preparDeleteSelectedCertificate(remoteResponse: e.response);
    } catch (e) {
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
