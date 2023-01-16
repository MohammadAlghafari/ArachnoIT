import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/call/delete_course.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/call/get_profile_courses.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/call/set_course.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/call/update_course.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/profile_provider_courses_interface.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/courses_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/new_course_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class ProfileProviderCoursesRepository extends ProfileProviderCoursesInterface {
  final GetProfileCourses getProfileCourses;
  final SetCourse setCourse;
  final UpdateCourse updateCourse;
  final DeleteCourse deleteCourse;
  ProfileProviderCoursesRepository({
    @required this.getProfileCourses,
    @required this.setCourse,
    @required this.updateCourse,
    @required this.deleteCourse,
  });
  @override
  Future<ResponseWrapper<List<CoursesResponse>>> getUeseProfileCourses({
    String healthcareProviderId,
    String searchString,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response = await getProfileCourses.getProviderProfileCourses(
          pageNumber: pageNumber,
          pageSize: pageSize,
          healthcareProviderId: healthcareProviderId,
          searchString: searchString);
      return _prepareGetUeseProfileCourses(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareGetUeseProfileCourses(remoteResponse: e.response);
    } catch (e) {
      return _prepareGetUeseProfileCourses(remoteResponse: null);
    }
  }

  ResponseWrapper<List<CoursesResponse>> _prepareGetUeseProfileCourses(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CoursesResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => CoursesResponse.fromJson(x))
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
  Future<ResponseWrapper<NewCourseResponse>> addNewCourse({
    String name,
    String place,
    String date,
    List<ImageType> file,
  }) async {
    try {
      Response response = await setCourse.setCourse(
        date: date,
        file: file,
        place: place,
        name: name,
      );
      return _prepareAddNewCourse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddNewCourse(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewCourse(remoteResponse: null);
    }
  }

  ResponseWrapper<NewCourseResponse> _prepareAddNewCourse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<NewCourseResponse>();
    if (remoteResponse != null) {
      res.data =
          NewCourseResponse.fromJson(remoteResponse.data[AppConst.ENTITY]);
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
  Future<ResponseWrapper<NewCourseResponse>> updateSelectedCourse({
    String name,
    String place,
    String date,
    List<ImageType> file,
    List<String> removedfiles,
    String id,
  }) async {
    try {
      Response response = await updateCourse.updateCourse(
        date: date,
        file: file,
        place: place,
        name: name,
        removedfiles: removedfiles,
        id: id,
      );
      return _prepareAddNewCourse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAddNewCourse(remoteResponse: e.response);
    } catch (e) {
      return _prepareAddNewCourse(remoteResponse: null);
    }
  }

  @override
  Future<ResponseWrapper<bool>> deleteSelectedCourse({
    String itemId,
  }) async {
    try {
      Response response = await deleteCourse.deleteCourse(itemId: itemId);
      return _preparDeleteSelectedCourse(remoteResponse: response);
    } on DioError catch (e) {
      print("the erros is $e");
      return _preparDeleteSelectedCourse(remoteResponse: e.response);
    } catch (e) {
      print("the erros is $e");
      return _preparDeleteSelectedCourse(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _preparDeleteSelectedCourse(
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
