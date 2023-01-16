import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class RemoveFromGroup {
  RemoveFromGroup({@required this.dio});
  final Dio dio;
  Future<dynamic> removeMemberFromGroup(
      {@required String userId, @required String groupId}) async {
    final _param = {
      "personId": userId,
      "requestStatus": 3,
      "id": groupId,
      "isValid": true
    };
    Response response = await dio.put(
      Urls.SET_GROUP_INOVATION,
      data: _param,
    );
    return response;
  }
}
