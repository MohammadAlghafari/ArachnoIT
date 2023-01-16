import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/call/accept_inovation.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/call/get_all_patents.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/call/reject_inovation.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/pendding_list_patents_interface.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/response/patents_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../api/response_type.dart' as ResType;

class PenddingListPatentsRepository implements PenddingListPatentsInterface {
  GetAllPatents getAllPatents;
  RejectPatentsInovation rejectPatentsInovation;
  AcceptPatentsInovation acceptPatentsInovation;
  PenddingListPatentsRepository(
      {@required this.getAllPatents,
      @required this.rejectPatentsInovation,
      @required this.acceptPatentsInovation});

  @override
  Future<ResponseWrapper<List<PatentsResponse>>> getAllPatentsList(
      {int pageNumber, int pageSize, String healthcareProviderId}) async {
    try {
      Response response = await getAllPatents.getAllPatents(
          healthcareProviderId: healthcareProviderId,
          pageNumber: pageNumber,
          pageSize: pageSize);
      return _prepareGetAllPatentsList(remoteResponse: response);
    } on DioError catch (e) {
      print("The errror is $e");
      return _prepareGetAllPatentsList(remoteResponse: e.response);
    } catch (e) {
      print("The errror is $e");
      return null;
    }
  }

  ResponseWrapper<List<PatentsResponse>> _prepareGetAllPatentsList(
      {@required Response remoteResponse}) {
    var res = ResponseWrapper<List<PatentsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => PatentsResponse.fromJson(x))
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
  Future<ResponseWrapper<bool>> acceptPendingPatentsInvitation(
      {String patentsId}) async {
    try {
      Response response =
          await acceptPatentsInovation.acceptInovations(patentsId: patentsId);
      return _prepareAcceptPendingPatentsInvitation(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAcceptPendingPatentsInvitation(remoteResponse: e.response);
    } catch (e) {
      return _prepareAcceptPendingPatentsInvitation(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareAcceptPendingPatentsInvitation(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
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
      res.errorMessage = "Error happened try again";
    }
    return res;
  }

  @override
  Future<ResponseWrapper<bool>> rejectPatents({String patentsId}) async {
    try {
      Response response =
          await rejectPatentsInovation.rejectInovations(patentsId: patentsId);
      return _prepareRejectPatents(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareRejectPatents(remoteResponse: e.response);
    } catch (e) {
      return _prepareRejectPatents(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareRejectPatents(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode ==200)
        res.data = true;
      else
        res.data = false;
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
      res.errorMessage = "Error happened try again";
    }
    return res;
  }
}
