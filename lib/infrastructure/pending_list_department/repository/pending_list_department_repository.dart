import 'dart:convert';

import 'package:arachnoit/application/pending_list_department/pending_list_department_bloc.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/Idepatment_remote.dart';
import 'package:arachnoit/infrastructure/pending_list_department/datasource/remote/fetch_pending_list_department.dart';
import 'package:arachnoit/infrastructure/pending_list_department/repository/Ipending_list_department_repository.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_by_id_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/department_model.dart';
import 'package:arachnoit/infrastructure/pending_list_department/response/join_leave_department_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../api/response_type.dart' as ResType;
import 'package:arachnoit/infrastructure/pending_list_department/utils/params.dart';

class PendingListDepartmentRepository with Handling implements IPendingListDepartmentRepository {
  final IDepartmentRemoteDataSource iDepartmentRemoteDataSource;

  FetchPendingListDepartmentRemote fetchPendingListDepartmentRemote;
  PendingListDepartmentRepository({@required this.iDepartmentRemoteDataSource});

  @override
  Future<ResponseWrapper<List<DepartmentModel>>> getAllDepartment({
    @required int pageNumber,
    @required int pageSize,
    @required String healthCareProviderId,
  }) async {
    try {

      Response response = await iDepartmentRemoteDataSource.fetchPendingListDepartment(
          GetDepartmentParam(
              pageNumber: pageNumber,
              pageSize: pageSize,
              healthCareProviderId: healthCareProviderId));

      return _prepareAdvanceSearchResponse(remoteResponse: response);
    } on DioError catch (e) {
      print("The error is $e");
      return _prepareAdvanceSearchResponse(remoteResponse: e.response);
    } catch (e) {
      print("The error is $e");
      return null;
    }
  }

  ResponseWrapper<List<DepartmentModel>> _prepareAdvanceSearchResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<DepartmentModel>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => DepartmentModel.fromJson(x))
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
  Future<ResponseWrapper<JoinLeaveDepartmentModel>> joinOrLeaveDepartment({
   @required String departmentId,
   @required RequestType requestType,
  }) async {
    try {
      Response response = await iDepartmentRemoteDataSource.joinOrLeaveDepartment(
          JoinOrLeaveDepartmentParam(
            departmentId: departmentId,
            requestType: requestType
          )
      );

      var responseWrapper = ResponseWrapper<JoinLeaveDepartmentModel>();


      final JoinLeaveDepartmentModel joinLeaveDepartmentModel = JoinLeaveDepartmentModel.fromJson(response.data);

      if (response != null) {
        responseWrapper.data = joinLeaveDepartmentModel;
        responseWrapper.enumResult = joinLeaveDepartmentModel.enumResult;
        responseWrapper.errorMessage = joinLeaveDepartmentModel.errorMessages;
        responseWrapper.successEnum = joinLeaveDepartmentModel.enumResult;
        responseWrapper.successMessage = joinLeaveDepartmentModel.successMessage;
        responseWrapper.opertationName = joinLeaveDepartmentModel.operationName;

        switch (response.statusCode) {
          case 200:
            responseWrapper.responseType = ResType.ResponseType.SUCCESS;
            break;
          case 400:
          case 401:
            responseWrapper.responseType = ResType.ResponseType.VALIDATION_ERROR;
            break;
          case 500:
            responseWrapper.responseType = ResType.ResponseType.SERVER_ERROR;
            break;
        }
      } else {
        responseWrapper.responseType = ResType.ResponseType.CLIENT_ERROR;
      }

      return responseWrapper;
    } on DioError catch (e) {
      var responseWrapper = ResponseWrapper<JoinLeaveDepartmentModel>();
      responseWrapper.errorMessage = e.message;
      responseWrapper.responseType = ResType.ResponseType.CLIENT_ERROR;
      return responseWrapper;
    } catch (e) {
      var responseWrapper = ResponseWrapper<JoinLeaveDepartmentModel>();
      responseWrapper.errorMessage = e.toString();
      responseWrapper.responseType = ResType.ResponseType.CLIENT_ERROR;
      return responseWrapper;
    }
  }

  @override
  Future<ResponseWrapper<DepartmentByIdModel>> getDepartmentById({@required String departmentId}) async {
    try {

      Response response = await iDepartmentRemoteDataSource
          .getDepartmentById(departmentId);

      var responseWrapper = ResponseWrapper<DepartmentByIdModel>();


      final DepartmentByIdModel departmentByIdModel = DepartmentByIdModel.fromJson(response.data);

      if (response != null) {
        responseWrapper.data = departmentByIdModel;
        responseWrapper.enumResult = null;
        responseWrapper.errorMessage = null;
        responseWrapper.successEnum = null;
        responseWrapper.successMessage = null;
        responseWrapper.opertationName = null;

        switch (response.statusCode) {
          case 200:
            responseWrapper.responseType = ResType.ResponseType.SUCCESS;
            break;
          case 400:
          case 401:
            responseWrapper.responseType = ResType.ResponseType.VALIDATION_ERROR;
            break;
          case 500:
            responseWrapper.responseType = ResType.ResponseType.SERVER_ERROR;
            break;
        }
      } else {
        responseWrapper.responseType = ResType.ResponseType.CLIENT_ERROR;
      }

      return responseWrapper;
    } on DioError catch (e) {
      var responseWrapper = ResponseWrapper<DepartmentByIdModel>();
      responseWrapper.responseType = ResType.ResponseType.CLIENT_ERROR;
      return responseWrapper;
    } catch (e) {

      var responseWrapper = ResponseWrapper<DepartmentByIdModel>();
      responseWrapper.responseType = ResType.ResponseType.CLIENT_ERROR;
      return responseWrapper;
    }

  }
}

mixin Handling{

  ResponseWrapper<T> handleRequest<T>({@required Response remoteResponse}) {
    final res = ResponseWrapper<T>();

    if(remoteResponse != null)
      {
        res.data = remoteResponse.data;
        res.enumResult = remoteResponse.data.enumResult;
        res.errorMessage = remoteResponse.data.errorMessage;
        res.successEnum = remoteResponse.data.successEnum;
        res.successMessage = remoteResponse.data.messageStatus;
        res.opertationName = remoteResponse.data.opertationName;
      }
      switch (remoteResponse?.statusCode) {
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

    return res;
  }

}
