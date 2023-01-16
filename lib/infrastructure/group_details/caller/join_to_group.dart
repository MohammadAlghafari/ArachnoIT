import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class JoinInGroup {
  JoinInGroup({@required this.dio});
  final Dio dio;
  Future<dynamic> joinInSelectedGroup({@required String groupId}) async {
    final _param = {"groupId": groupId};
    Response response = await dio.put(
      Urls.JOIN_IN_GROUP,
      queryParameters: _param,
    );
    return response;
  }
}
