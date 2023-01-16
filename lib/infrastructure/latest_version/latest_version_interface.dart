import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/latest_version/response/latest_version_response.dart';

abstract class LatestVersionInterface{
  Future<ResponseWrapper<LatestVersionResponse>> getVersion();
   
}