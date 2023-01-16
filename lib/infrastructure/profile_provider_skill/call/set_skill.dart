import 'dart:io';

import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SetSkill {
  final Dio dio;
  SetSkill({@required this.dio});
  Future<dynamic> setSkill({
    String name,
    String startDate,
    String endDate,
    String description,
    String itemId="",
  }) async {
    final _map = {
      "name": name,
      "startDate": startDate,
      "endDate": endDate,
      "description": description,
    };
    if (itemId != null || itemId.length != 0) _map['id'] = itemId;
    Response response = await dio.post(Urls.SET_SKILL, data: _map);
    return response;
  }
}
