import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetEmphasisVotes {
  final Dio dio;
  GetEmphasisVotes({@required this.dio});

  Future<dynamic> getEmphasisUsefulVotes({
    @required int pageNumber,
    @required int pageSize,
    @required String itemId,
    @required int voteType,
  }) async {
    final _param = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "votesCriteria.itemId":itemId,
      "votesCriteria.voteType":1,
      "votesCriteria.itemType":2
    };
    Response response = await dio.get(Urls.GET_VOTES, queryParameters: _param);
    return response;
  }
}
