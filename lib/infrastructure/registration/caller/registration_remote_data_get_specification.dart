import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class RegistrationRemoteDataGetSpecification {
  RegistrationRemoteDataGetSpecification({@required this.dio});
  final Dio dio;

   

  Future<dynamic> getSpecification({
    @required accountTypeId,
  }
      ) async {
          final params = {
      'accountTypeId': accountTypeId,
    };
    Response response = await dio.get(Urls.SPECIFICATION,queryParameters: params);
    return response;
  }

  
  }