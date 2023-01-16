import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class RegistrationRemoteDataGetAccountTypes {
  RegistrationRemoteDataGetAccountTypes({@required this.dio});
  final Dio dio;

  Future<dynamic> getAccountTypes(
  
      ) async {
        
    Response response = await dio.get(Urls.ACCOUNT_TYPES, );
    return response;
  }
  
}