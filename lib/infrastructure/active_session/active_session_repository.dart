import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/active_session/active_session_interface.dart';
import 'package:arachnoit/infrastructure/active_session/caller/remote/get_all_active_session.dart';
import 'package:arachnoit/infrastructure/active_session/caller/remote/make_report.dart';
import 'package:arachnoit/infrastructure/active_session/response/active_session_model.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class ActiveSessionRepository implements ActiveSessionInterface {
  GetAllActiveSession getAllActiveSessionItem;
  MakeReport makeReport;
  ActiveSessionRepository(
      {@required this.getAllActiveSessionItem, @required this.makeReport});
  @override
  Future<ResponseWrapper<List<ActiveSessionModel>>>
      getAllActiveSession() async {
    try {
      Response response = await getAllActiveSessionItem.getAllActiveSession();
      return _prepareGetAllActiveSession(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetAllActiveSession(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetAllActiveSession(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<ActiveSessionModel>> _prepareGetAllActiveSession(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<ActiveSessionModel>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => ActiveSessionModel.fromJson(x))
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
  Future<ResponseWrapper<bool>> sendReport(
      {String itemId, String message}) async {
    try {
      Response response =
          await makeReport.sendReport(itemId: itemId, message: message);
      return _prepareSendReport(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSendReport(remoteResponse: e.response);
    } catch (e) {
      return _prepareSendReport(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareSendReport(
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
    }
    return res;
  }
}
