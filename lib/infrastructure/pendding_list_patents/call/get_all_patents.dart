import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';

class GetAllPatents {
  final Dio dio;

  GetAllPatents({this.dio});

  Future<dynamic> getAllPatents({
    int pageNumber,
    int pageSize,
    String healthcareProviderId,
  }) async {
    final _param = {
      "healthcareProviderId": healthcareProviderId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "ownershipType": 2,
      "approvalListOnly": false,
      "enablePagination": true
    };
    Response response =
        await dio.get(Urls.GET_PATENTS, queryParameters: _param);
    return response;
  }
}
