import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/latest_version/caller/get_latest_version.dart';
import 'package:arachnoit/infrastructure/latest_version/latest_version_interface.dart';
import 'package:arachnoit/infrastructure/latest_version/response/latest_version_response.dart';
import 'package:dio/dio.dart';
import '../api/response_type.dart' as ResType;
import 'package:flutter/cupertino.dart';

class LatestVersionRepository implements LatestVersionInterface {
  final GetLatestVersion getLatestVersion;
  LatestVersionRepository({@required this.getLatestVersion});

  @override
  Future<ResponseWrapper<LatestVersionResponse>> getVersion() async {
    try {
      Response response = await getLatestVersion.getLatestVersion();
      return _prepareGetVersion(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetVersion(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetVersion(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<LatestVersionResponse> _prepareGetVersion(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<LatestVersionResponse>();
    if (remoteResponse != null) {
      res.data = LatestVersionResponse.fromJson(remoteResponse.data);
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
