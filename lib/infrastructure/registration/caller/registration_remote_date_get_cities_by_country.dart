import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class RegistrationRemoteDataGetCitiesByCountry {
  RegistrationRemoteDataGetCitiesByCountry({@required this.dio});
  final Dio dio;

   

  Future<dynamic> getCitiesByCountries({
    @required countryId,
  }
      ) async {
         final params = {
      'countryId': countryId,
    };
    Response response = await dio.get(Urls.CITIES_BY_COUNTRY, queryParameters: params);
    return response;
  }

  
  }