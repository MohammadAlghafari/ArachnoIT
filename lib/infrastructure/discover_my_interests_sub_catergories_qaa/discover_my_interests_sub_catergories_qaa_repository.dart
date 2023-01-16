import '../api/response_wrapper.dart';
import 'call/get_my_interests_sub_catergories_qaa_interface_remote.dart';
import 'discover_my_interests_sub_catergories_qaa_interface.dart';
import '../home_qaa/response/qaa_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class DiscoverMyInterestsSubCatergoriesQaaRepository
    implements DiscoverMyInterestsSubCatergoriesQaaInterface {
  final GetMyInterestsSubCatergoriesQaaInterfaceRemote
      getMyInterestsSubCatergoriesQaaInterfaceRemote;
  DiscoverMyInterestsSubCatergoriesQaaRepository(
      {@required this.getMyInterestsSubCatergoriesQaaInterfaceRemote});
  @override
  Future<ResponseWrapper<List<QaaResponse>>> getInterestsSubCategoriesQaaRemote(
      {int pageNumber, int pageSize, String subCategoryId}) async {
    try {
      Response response = await getMyInterestsSubCatergoriesQaaInterfaceRemote
          .getInterestsSubCategoriesQaaRemote(
              pageNumber: pageNumber,
              pageSize: pageSize,
              subCategoryId: subCategoryId);
      return _prepareQaaResponse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareQaaResponse(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<QaaResponse>> _prepareQaaResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<QaaResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => QaaResponse.fromMap(x))
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
