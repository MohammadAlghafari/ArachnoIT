import '../../api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetMyInterestsSubCatergoriesQaaInterfaceRemote {
  final Dio dio;
  GetMyInterestsSubCatergoriesQaaInterfaceRemote({@required this.dio});
  Future<dynamic> getInterestsSubCategoriesQaaRemote({
    @required int pageNumber,
    @required int pageSize,
    @required String subCategoryId,
  }) async {
    final params = {
      'subCategoryId': subCategoryId ?? "",
      'pageNumber': pageNumber ?? "",
      'pageSize': pageSize ?? "",
    };
    Response response = await dio.get(Urls.GET_QAAS, queryParameters: params);
    return response;
  }
}
