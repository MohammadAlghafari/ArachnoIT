import 'dart:io';

import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/call/set_new_certificate.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/call/delete_experiance.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/call/set_new_experiance.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/call/update_experiance.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/profile_provider_experiance_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/response/experiance_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/response/new_experiance_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../application/profile_provider_experiance/profile_provider_experiance_bloc.dart';
import '../api/response_type.dart' as ResType;
import 'call/get_profile_experiance.dart';

class ProfileProviderExperianceRepository
    implements ProfileProviderExperianceInterface {
  GetProfileExperiance getProfileExperiance;
  SetNewExperiance setNewExperiance;
  final UpdateExperiance updateExperiance;
  DeleteExperiance deleteExperiance;
  ProfileProviderExperianceRepository({
    this.getProfileExperiance,
    @required this.setNewExperiance,
    @required this.updateExperiance,
    @required this.deleteExperiance,
  });
  @override
  Future<ResponseWrapper<List<ExperianceResponse>>> getUserProfileExperiance({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response =
          await getProfileExperiance.getProviderProfileExperiance(
              pageNumber: pageNumber,
              pageSize: pageSize,
              healthcareProviderId: healthcareProviderId,
              searchString: searchString);
      return _preparegetUserProfileExperiance(remoteResponse: response);
    } on DioError catch (e) {
      return _preparegetUserProfileExperiance(remoteResponse: e.response);
    } catch (e) {
      return _preparegetUserProfileExperiance(remoteResponse: null);
    }
  }

  ResponseWrapper<List<ExperianceResponse>> _preparegetUserProfileExperiance(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<ExperianceResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => ExperianceResponse.fromJson(x))
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
  Future<ResponseWrapper<NewExperianceResponse>> updateSelectedExperiance(
      {String name,
      String startDate,
      String endDate,
      String organization,
      String url,
      List<ImageType> file,
      String description,
      String id,
      List<String>removedfiles
      }) async {
    try {
      Response response = await updateExperiance.updateExperiance(
          url: url,
          description: description,
          endDate: endDate,
          file: file,
          name: name,
          organization: organization,
          startDate: startDate,
          id: id,
          removedfiles: removedfiles
          );
      return _prepareAddNewExperiance(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddNewExperiance(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewExperiance(remoteResponse: null);
    }
  }

  @override
  Future<ResponseWrapper<NewExperianceResponse>> addNewExperiance({
    String name,
    String startDate,
    String endDate,
    String organization,
    String url,
    List<ImageType> file,
    String description,
  }) async {
    try {
      Response response = await setNewExperiance.addNewExperiance(
        url: url,
        description: description,
        endDate: endDate,
        file: file,
        name: name,
        organization: organization,
        startDate: startDate,
      );
      return _prepareAddNewExperiance(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddNewExperiance(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewExperiance(remoteResponse: null);
    }
  }

  ResponseWrapper<NewExperianceResponse> _prepareAddNewExperiance(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewExperianceResponse>();
    if (remoteResponse != null) {
      res.data =
          NewExperianceResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<bool>> deleteSelectedExperiance({
    String itemId,
  }) async {
    try {
      Response response = await deleteExperiance.deleteExperiance(itemId: itemId);
      return _preparDeleteSelectedExperiance(remoteResponse: response);
    } on DioError catch (e) {
      return _preparDeleteSelectedExperiance(remoteResponse: e.response);
    } catch (e) {
      return _preparDeleteSelectedExperiance(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparDeleteSelectedExperiance(
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
