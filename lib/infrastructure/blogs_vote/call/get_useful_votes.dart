import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetVotes {
  final Dio dio;
  GetVotes({@required this.dio});

  Future<dynamic> getBlogsUsefulVotes({
    @required int pageNumber,
    @required int pageSize,
    @required String itemId,
    @required int voteType,
    @required int itemType,
  }) async {
    final _param = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "votesCriteria.itemId":itemId,
      "votesCriteria.voteType":voteType,
      "votesCriteria.itemType":itemType
    };
    Response response = await dio.get(Urls.GET_VOTES, queryParameters: _param);
    return response;
  }
}
