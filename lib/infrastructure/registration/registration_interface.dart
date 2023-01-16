import 'package:arachnoit/infrastructure/registration/response/account_types_response.dart';
import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import 'response/cities_by_country_response.dart';
import 'response/country_reponse.dart';
import '../common_response/specification_response.dart';
import '../common_response/sub_specification_response.dart';

abstract class RegistrationInterface {
  Future<ResponseWrapper<List<CountryResponse>>> getCountries();

  Future<ResponseWrapper<List<CitiesByCountryResponse>>> getCitiesByCountry({
    @required countryId,
  });

  Future<ResponseWrapper<List<AccountTypesResponse>>> getAccountTypes();

  Future<ResponseWrapper<List<SpecificationResponse>>> getSpecification(
      {@required accountTypeId});

  Future<ResponseWrapper<List<SubSpecificationResponse>>> getSubSpecification({
    @required specificationId,
  });

  Future<ResponseWrapper<List<dynamic>>>
      isTouchPointNameEmailMobileAvailable({
    @required touchPointName,
    @required email,
    @required mobile,
  });

   Future<ResponseWrapper<List<dynamic>>>
      isEmailMobileAvailable({
    @required email,
    @required mobile,
  });

  Future<ResponseWrapper<String>>
      registerHealthCareProvider({
    @required inTouchPointName,
    @required subSpecificationId,
    @required email,
    @required firstName,
    @required lastName,
    @required birthdate,
    @required gender,
    @required password,
    @required mobile,
    @required cityId,
  });

  Future<ResponseWrapper<String>>
      registerNormalUser({
    @required email,
    @required firstName,
    @required lastName,
    @required birthdate,
    @required gender,
    @required password,
    @required mobile,
    @required cityId,
  });
}
