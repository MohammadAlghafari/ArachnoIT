import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/provider_item_response.dart';
import 'caller/get_favorite_providers_remote_data_provider.dart';
import 'providers_favorite_interface.dart';

class ProvidersFavoriteRepository implements ProvidersFavoriteInterface {
  ProvidersFavoriteRepository({
    @required this.getFavoriteProvidersRemoteDataProvider,
  });

  final GetFavoriteProvidersRemoteDataProvider
      getFavoriteProvidersRemoteDataProvider;

  @override
  Future<ResponseWrapper<List<ProviderItemResponse>>> getFavoriteProviders(
      {String searchString, int pageNumber, int pageSize}) async {
    try {
      Response response =
          await getFavoriteProvidersRemoteDataProvider.getFavoriteProviders(
        searchString: searchString,
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
      if (remoteResponse.statusCode == 200 && remoteResponse.data == null)
        res.data = [];
      else {
        res.data = (remoteResponse.data as List)
            .map((x) => ProviderItemResponse.fromMap(x))
            .toList();
      }
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
