import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetGroupPermissionsRemoteDataProvider {
  const GetGroupPermissionsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getGroupPermission() async {

    Response response = await dio.get(Urls.Group_Permission);
    return response;
  }
}
