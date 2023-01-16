import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api/urls.dart';

class SearchProviderRemoteGetSubSpecification {
  SearchProviderRemoteGetSubSpecification({@required this.dio});
  final Dio dio;

   

 Future<dynamic> getSubSpecification({
    @required specificationId,
  }
      ) async {
         final params = {
      'specificationId': specificationId,
    };
    Response response = await dio.get(Urls.SUB_SPECIFICSTION, queryParameters: params);
    return response;
  }
  
  }