import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/call/delete_project.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/call/set_project.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/call/update_project.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/profile_provider_projects_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/new_projects_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/projects_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import 'call/get_profile_projects.dart';

class ProfileProviderProjectsRepository
    implements ProfileProviderProjectsInterface {
  final GetProfileProjects getProfileProjects;
  final UpdateProject updateProject;
  final SetProject setProject;
  final DeleteProject deleteProject;
  ProfileProviderProjectsRepository({
    @required this.getProfileProjects,
    @required this.setProject,
    @required this.updateProject,
    @required this.deleteProject,
  });
  @override
  Future<ResponseWrapper<List<ProjectsResponse>>> getUserProfileProjects({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response = await getProfileProjects.getProviderProfileProjects(
          pageNumber: pageNumber,
          pageSize: pageSize,
          healthcareProviderId: healthcareProviderId,
          searchString: searchString);
      return _prepareGetUserProfileProjects(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetUserProfileProjects(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetUserProfileProjects(remoteResponse: null);
    }
  }

  ResponseWrapper<List<ProjectsResponse>> _prepareGetUserProfileProjects(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<ProjectsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => ProjectsResponse.fromJson(x))
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
  Future<ResponseWrapper<NewProjectResponse>> addNewProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
    String description,
  }) async {
    try {
      Response response = await setProject.setProject(
        endDate: endDate,
        file: file,
        startDate: startDate,
        name: name,
        link: link,
        description: description,
      );
      return _prepareAddNewProject(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddNewProject(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewProject(remoteResponse: null);
    }
  }

  ResponseWrapper<NewProjectResponse> _prepareAddNewProject(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewProjectResponse>();
    if (remoteResponse != null) {
      res.data =
          NewProjectResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<NewProjectResponse>> updateSelectedProject({
    String name,
    String startDate,
    String endDate,
    String link,
    List<ImageType> file,
    String description,
    String id,
    List<String> removedfiles,
  }) async {
    try {
      Response response = await updateProject.updateProject(
        endDate: endDate,
        file: file,
        startDate: startDate,
        name: name,
        link: link,
        description: description,
        id: id,
        removedfiles: removedfiles,
      );
      return _prepareAddNewProject(remoteResponse: response);
    } on DioError catch (e) {
      print("the errorrrrrrr $e");
      return _prepareAddNewProject(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewProject(remoteResponse: null);
    }
  }

  @override
  Future<ResponseWrapper<bool>> deleteSeletecteProject({
    String itemId,
  }) async {
    try {
      Response response = await deleteProject.deleteProject(
        itemId: itemId,
      );
      return _preparDeleteSelectedProject(remoteResponse: response);
    } on DioError catch (e) {
      return _preparDeleteSelectedProject(remoteResponse: e.response);
    } catch (e) {
      return _preparDeleteSelectedProject(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparDeleteSelectedProject(
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