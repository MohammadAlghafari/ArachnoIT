import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';

class GetProfileFollowListInfo {
  final Dio dio;

  GetProfileFollowListInfo({
    this.dio,
  });

  Future<dynamic> getProfileFollowListInfo({
    String healthcareProviderId,
  }) async {
    final _param = {"healthcareProviderId": healthcareProviderId};
    Response response =
        await dio.get(Urls.GET_PROFILE_FOLLOW_LIST, queryParameters: _param);
    return response;
  }
}
