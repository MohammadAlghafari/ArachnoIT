import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/provider_item_response.dart';
import 'caller/get_all_providers_remote_data_call_providers.dart';
import 'providers_all_interface.dart';

class ProvidersAllRepository implements ProvidersAllInterface {
  ProvidersAllRepository({this.getAllProvidersRemoteDataProvider});

  final GetAllProvidersRemoteDataProvider getAllProvidersRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<ProviderItemResponse>>> getAllProviders(
      {int pageNumber, int pageSize}) async {
    try {
      Response response =
          await getAllProvidersRemoteDataProvider.getAllProviders(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return _prepareProvidersResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareProvidersResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareProvidersResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<ProviderItemResponse>> _prepareProvidersResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<ProviderItemResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => ProviderItemResponse.fromMap(x))
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
}
