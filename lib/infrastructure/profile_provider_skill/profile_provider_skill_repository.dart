import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/call/delete_skill.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/call/get_profile_skills.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/call/set_skill.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/profile_provider_skill_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/new_skill_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/skills_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class ProfileProviderSkillRepository implements ProfileProviderSkillInterface {
  final GetProfileSkills getProfileSkills;
  final SetSkill setSkill;
  final DeleteSkill deleteSkill;
  ProfileProviderSkillRepository(
      {@required this.getProfileSkills,
      @required this.setSkill,
      @required this.deleteSkill});
  @override
  Future<ResponseWrapper<List<SkillsResponse>>> getUeseProfileSkills({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response = await getProfileSkills.getProviderProfileSkills(
          pageNumber: pageNumber,
          pageSize: pageSize,
          healthcareProviderId: healthcareProviderId,
          searchString: searchString);
      return _prepareGetUeseProfileSkills(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetUeseProfileSkills(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetUeseProfileSkills(remoteResponse: null);
    }
  }

  ResponseWrapper<List<SkillsResponse>> _prepareGetUeseProfileSkills(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<SkillsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => SkillsResponse.fromJson(x))
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
  Future<ResponseWrapper<NewSkillResponse>> setNewSkill({
    String name,
    String startDate,
    String endDate,
    String itemId,
    String description,
  }) async {
    try {
      Response response = await setSkill.setSkill(
        endDate: endDate,
        startDate: startDate,
        name: name,
        description: description,
        itemId: itemId,
      );
      return _prepareSetNewSkill(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSetNewSkill(remoteResponse: e.response);
    } catch (e) {
      return _prepareSetNewSkill(remoteResponse: null);
    }
  }

  ResponseWrapper<NewSkillResponse> _prepareSetNewSkill(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewSkillResponse>();
    if (remoteResponse != null) {
      res.data =
          NewSkillResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<bool>> deleteSelectedSkill({
    String itemId,
  }) async {
    try {
      Response response = await deleteSkill.deleteSkill(
        itemId: itemId,
      );
      return _preparDeleteSelectedSkill(remoteResponse: response);
    } on DioError catch (e) {
      return _preparDeleteSelectedSkill(remoteResponse: e.response);
    } catch (e) {
      return _preparDeleteSelectedSkill(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparDeleteSelectedSkill(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      res.data = false;
      if (remoteResponse.statusCode == 200) res.data = false;
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
