import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SetEmphasisVoteForBlogDetailsRemoteDataProvider {
  SetEmphasisVoteForBlogDetailsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> setEmphasisVoteForBlogDetails({
    @required String itemId,
    @required bool status,
  }) async {
    final params = {
      'itemId': itemId,
      'status': status,
    };
    Response response = await dio.put(Urls.SET_EMPHASIS_VOTE_FOR_BLOG, data: params);
    return response;
  }
}