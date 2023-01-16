import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/call/delete_lectures.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/call/update_lectures.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/profile_provider_lectures_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/new_lectures_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/qualifications_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import 'call/add_new_lectures.dart';
import 'call/get_profile_lecture.dart';

class ProfileProviderLecturesRepository
    implements ProfileProviderLecturesInterface {
  final GetProfileLecture getProfileLecture;
  final AddNewLectures addNewLectures;
  final UpdateLectures updateLectures;
  final RemoverLectures removerLectures;
  ProfileProviderLecturesRepository({
    @required this.getProfileLecture,
    @required this.addNewLectures,
    @required this.updateLectures,
    @required this.removerLectures,
  });
  @override
  Future<ResponseWrapper<List<QualificationsResponse>>> getUserProfileLecture({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response = await getProfileLecture.getProviderProfileLecture(
          pageNumber: pageNumber,
          pageSize: pageSize,
          healthcareProviderId: healthcareProviderId,
          searchString: searchString);
      return _prepareGetUserProfileQualification(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetUserProfileQualification(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetUserProfileQualification(remoteResponse: null);
    }
  }

  ResponseWrapper<List<QualificationsResponse>>
      _prepareGetUserProfileQualification(
          {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<QualificationsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => QualificationsResponse.fromJson(x))
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
  Future<ResponseWrapper<NewLecturesResponse>> setNewLectures({
    String title,
    String description,
    List<ImageType> file,
  }) async {
    try {
      Response response = await addNewLectures.addNewLectures(
          file: file, description: description, title: title);
      return _prepareAddNewLectures(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddNewLectures(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewLectures(remoteResponse: null);
    }
  }

  ResponseWrapper<NewLecturesResponse> _prepareAddNewLectures(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewLecturesResponse>();
    if (remoteResponse != null) {
      res.data =
          NewLecturesResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<NewLecturesResponse>> updateSelectedLectures({
    String title,
    String description,
    String itemID,
    List<ImageType> file,
    List<String> removedFile,
  }) async {
    try {
      Response response = await updateLectures.updateLectures(
        file: file,
        description: description,
        title: title,
        removedFile: removedFile,
        itemId: itemID,
      );
      return _prepareAddNewLectures(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddNewLectures(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewLectures(remoteResponse: null);
    }
  }

  @override
  Future<ResponseWrapper<bool>> deleteSelectedLectures({
    String itemId,
  }) async {
    try {
      Response response = await removerLectures.removerLectures(itemId: itemId);
      return _prepareDeleteSelectedLectures(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareDeleteSelectedLectures(remoteResponse: e.response);
    } catch (e) {
      return _prepareDeleteSelectedLectures(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareDeleteSelectedLectures(
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
