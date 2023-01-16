import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/pendding_list_patents/response/patents_response.dart';
import 'package:flutter/cupertino.dart';

abstract class PenddingListPatentsInterface {
  Future<ResponseWrapper<List<PatentsResponse>>> getAllPatentsList({
    int pageNumber,
    int pageSize,
    String healthcareProviderId,
  });

  Future<ResponseWrapper<bool>> rejectPatents(
      {@required String patentsId});
  Future<ResponseWrapper<bool>> acceptPendingPatentsInvitation(
      {@required String patentsId});
}
