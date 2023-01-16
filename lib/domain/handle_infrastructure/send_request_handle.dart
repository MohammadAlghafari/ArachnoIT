import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/domain/handle_infrastructure/handle_infrastructure_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SendRequest<T> {
  sendCurrentRequest({
    @required Function() requestFunction,
    @required Function(dynamic x) fromJson,
    bool dataFromEntity = false,
    bool needList = false,
    bool responseWithErrorMessage = false,
    // ignore: avoid_init_to_null
    Function(Response response) needMyOwnConvertFunction = null,
  }) async {
    try {
      Response response = await requestFunction();
      bool myOwnFunction = false;
      if (needMyOwnConvertFunction != null) myOwnFunction = true;
      if (needList) {
        HandleResponse<List<T>> handleResponse = HandleResponse<List<T>>();
        if (dataFromEntity) {
          return handleResponse.getResponseWrapper(
              response: response,
              convertResposeFunction: (x) => !myOwnFunction
                  ? (response.data as List)
                      .map((x) => fromJson(x.data[AppConst.ENTITY]) as T)
                      .toList()
                  : needMyOwnConvertFunction(response),
              responseWithErrorMessage: responseWithErrorMessage);
        } else {
          return (handleResponse.getResponseWrapper(
              response: response,
              convertResposeFunction: (x) => !myOwnFunction
                  ? (response.data as List).map((x) => fromJson(x) as T).toList()
                  : needMyOwnConvertFunction(response),
              responseWithErrorMessage: responseWithErrorMessage));
        }
      } else {
        HandleResponse<T> handleResponse = HandleResponse<T>();
        if (dataFromEntity) {
          return handleResponse.getResponseWrapper(
              convertResposeFunction: (x) => !myOwnFunction
                  ? fromJson(response.data[AppConst.ENTITY]) as T
                  : needMyOwnConvertFunction(response),
              response: response,
              responseWithErrorMessage: responseWithErrorMessage);
        } else {
          return await handleResponse.getResponseWrapper(
              convertResposeFunction: (x) => !myOwnFunction
                  ? fromJson(response.data) as T
                  : needMyOwnConvertFunction(response),
              response: response,
              responseWithErrorMessage: responseWithErrorMessage);
        }
      }
    } on DioError catch (_) {
      HandleResponse<T> handleResponse = HandleResponse<T>();
      return await handleResponse.getResponseWrapper(
          convertResposeFunction: (x) => fromJson(null),
          response: null,
          responseWithErrorMessage: responseWithErrorMessage);
    } catch (e) {
      print("The errir is $e");
      HandleResponse<T> handleResponse = HandleResponse<T>();
      return await handleResponse.getResponseWrapper(
          convertResposeFunction: (x) => fromJson(null),
          response: null,
          responseWithErrorMessage: responseWithErrorMessage);
    }
  }
}
