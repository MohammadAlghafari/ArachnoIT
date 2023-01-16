import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetBlogsVoteItemProfileBrife {
  final Dio dio;
  GetBlogsVoteItemProfileBrife({@required this.dio});

  Future<dynamic> getProfileBriefInfo({@required String id}) async {
    Response response = await dio.get(
      Urls.GET_BRIEF_PROFILE + "/" + id,
    );
    return response;
  }
}
