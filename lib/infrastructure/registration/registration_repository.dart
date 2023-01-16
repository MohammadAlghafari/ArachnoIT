import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import 'caller/registration_local_data_provider.dart';
import 'caller/registration_remote_data_get_account_types.dart';
import 'caller/registration_remote_data_get_countries.dart';
import 'caller/registration_remote_data_get_specification.dart';
import 'caller/registration_remote_data_get_sub_specification.dart';
import 'caller/registration_remote_data_is_email_mobile_available.dart';
import 'caller/registration_remote_data_is_touch_point_name_email_mobile_available.dart';
import 'caller/registration_remote_data_register_health_care_provider.dart';
import 'caller/registration_remote_data_register_normal_user.dart';
import 'caller/registration_remote_date_get_cities_by_country.dart';
import 'registration_interface.dart';
import 'response/account_types_response.dart';
import 'response/cities_by_country_response.dart';
import 'response/country_reponse.dart';
import 'response/email_available_response.dart';
import 'response/phone_number_available.dart';
import '../common_response/specification_response.dart';
import '../common_response/sub_specification_response.dart';
import 'response/touch_point_name_available.dart';

class RegistrationRepository implements RegistrationInterface {
  RegistrationRepository({
    @required this.registrationLocalDataProvider,
    @required this.registrationRemoteDataGetCitiesByCountry,
    @required this.registrationRemoteDataGetCountries,
    @required this.registrationRemoteDataGetSpecification,
    @required this.registrationRemoteDataGetSubSpecification,
    @required this.registrationRemoteDataGetAccountTypes,
    @required this.registrationRemoteDataIsTouchPointNameEmailMobileAvailable,
    @required this.registrationRemoteDataIsEmailMobileAvailable,
    @required this.registrationRemoteDataRegisterHealthCareProvider,
    @required this.registrationRemoteDataRegisterNormalUser,
  });

  final RegistrationLocalDataProvider registrationLocalDataProvider;
  final RegistrationRemoteDataGetCitiesByCountry
      registrationRemoteDataGetCitiesByCountry;
  final RegistrationRemoteDataGetCountries registrationRemoteDataGetCountries;
  final RegistrationRemoteDataGetSpecification
      registrationRemoteDataGetSpecification;
  final RegistrationRemoteDataGetSubSpecification
      registrationRemoteDataGetSubSpecification;
  final RegistrationRemoteDataGetAccountTypes
      registrationRemoteDataGetAccountTypes;
  final RegistrationRemoteDataIsTouchPointNameEmailMobileAvailable
      registrationRemoteDataIsTouchPointNameEmailMobileAvailable;
  final RegistrationRemoteDataIsEmailMobileAvailable
      registrationRemoteDataIsEmailMobileAvailable;
  final RegistrationRemoteDataRegisterHealthCareProvider
      registrationRemoteDataRegisterHealthCareProvider;
  final RegistrationRemoteDataRegisterNormalUser registrationRemoteDataRegisterNormalUser;

  @override
  Future<ResponseWrapper<List<AccountTypesResponse>>> getAccountTypes() async {
    try {
      Response response =
          await registrationRemoteDataGetAccountTypes.getAccountTypes();
      return _prepareAccountTypesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareAccountTypesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ResponseWrapper<List<CitiesByCountryResponse>>> getCitiesByCountry(
      {countryId}) async {
    try {
      Response response =
          await registrationRemoteDataGetCitiesByCountry.getCitiesByCountries(
        countryId: countryId,
      );
      return _prepareCitiesByCountryResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCitiesByCountryResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ResponseWrapper<List<CountryResponse>>> getCountries() async {
    try {
      Response response =
          await registrationRemoteDataGetCountries.getCountries();
      return _prepareCountriesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCountriesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ResponseWrapper<List<SpecificationResponse>>> getSpecification(
      {accountTypeId}) async {
    try {
      Response response =
          await registrationRemoteDataGetSpecification.getSpecification(
        accountTypeId: accountTypeId,
      );
      return _prepareSpecificationResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSpecificationResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ResponseWrapper<List<SubSpecificationResponse>>> getSubSpecification(
      {specificationId}) async {
    try {
      Response response =
          await registrationRemoteDataGetSubSpecification.getSubSpecification(
        specificationId: specificationId,
      );
      return _prepareSubSpecificationResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSubSpecificationResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ResponseWrapper<List<dynamic>>> isTouchPointNameEmailMobileAvailable(
      {touchPointName, email, mobile}) async {
    try {
      List<Response> responses =
          await registrationRemoteDataIsTouchPointNameEmailMobileAvailable
              .isTouchPointNameEmailMobileAvailabe(
                  touchPointName: touchPointName,
                  email: email,
                  phoneNumber: mobile);
      return _prepareIsTouchPointNameEmailMobileAvailableResponse(
        remoteResponses: responses,
      );
    } catch (e) {
      return e;
    }
  }

  @override
  Future<ResponseWrapper<List<dynamic>>> isEmailMobileAvailable(
      {email, mobile}) async {
    try {
      List<Response> responses =
          await registrationRemoteDataIsEmailMobileAvailable
              .isEmailMobileAvailabe(email: email, phoneNumber: mobile);
      return _prepareIsEmailMobileAvailableResponse(
        remoteResponses: responses,
      );
    } catch (e) {
      return e;
    }
  }

  @override
  Future<ResponseWrapper<String>> registerHealthCareProvider (
      {inTouchPointName,
      subSpecificationId,
      email,
      firstName,
      lastName,
      birthdate,
      gender,
      password,
      mobile,
      cityId}) async {
    try {
      Response response = await registrationRemoteDataRegisterHealthCareProvider.registerHealthCareProvider(
        inTouchPointName: inTouchPointName,
        subSpecificationId: subSpecificationId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        gender: gender,
        password: password,
        mobile: mobile,
        cityId: cityId,
      );
      return _prepareRegisteredUserResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareRegisteredUserResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ResponseWrapper<String>> registerNormalUser({email, firstName, lastName, birthdate, gender, password, mobile, cityId}) async{
   try {
      Response response = await registrationRemoteDataRegisterNormalUser.registerNormalUser(
        email: email,
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        gender: gender,
        password: password,
        mobile: mobile,
        cityId: cityId,
      );
      return _prepareRegisteredUserResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareRegisteredUserResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<CountryResponse>> _prepareCountriesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CountryResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => CountryResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  ResponseWrapper<List<CitiesByCountryResponse>>
      _prepareCitiesByCountryResponse(
          {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CitiesByCountryResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => CitiesByCountryResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  ResponseWrapper<List<SpecificationResponse>> _prepareSpecificationResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<SpecificationResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => SpecificationResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  ResponseWrapper<List<SubSpecificationResponse>>
      _prepareSubSpecificationResponse(
          {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<SubSpecificationResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => SubSpecificationResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  ResponseWrapper<List<AccountTypesResponse>> _prepareAccountTypesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<AccountTypesResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => AccountTypesResponse.fromMap(x))
          .toList();
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  
 
  ResponseWrapper<List<dynamic>>
      _prepareIsTouchPointNameEmailMobileAvailableResponse(
          {@required List<Response> remoteResponses}) {
    var res = ResponseWrapper<List<dynamic>>();
    if (remoteResponses != null) {
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      res.data = [];
      res.data.add(
          TouchPointNameAvailableResponse.fromMap(remoteResponses[0].data)
              );
      res.data.add(
          EmailAvailableResponse.fromMap(remoteResponses[1].data));
      res.data.add(PhoneNumberAvailableResponse.fromMap(remoteResponses[2].data)
          );
      if (remoteResponses[0].statusCode == 200 &&
          remoteResponses[1].statusCode == 200 &&
          remoteResponses[2].statusCode == 200)
        res.responseType = ResType.ResponseType.SUCCESS;
      else if (remoteResponses[0].statusCode == 400 ||
          remoteResponses[1].statusCode == 400 ||
          remoteResponses[2].statusCode == 400 ||
          remoteResponses[0].statusCode == 401 ||
          remoteResponses[1].statusCode == 401 ||
          remoteResponses[2].statusCode == 401)
        res.responseType = ResType.ResponseType.VALIDATION_ERROR;
      else if (remoteResponses[0].statusCode == 500 ||
          remoteResponses[1].statusCode == 500 ||
          remoteResponses[2].statusCode == 500)
        res.responseType = ResType.ResponseType.SERVER_ERROR;
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  ResponseWrapper<List<dynamic>> _prepareIsEmailMobileAvailableResponse(
      {@required List<Response> remoteResponses}) {
    var res = ResponseWrapper<List<dynamic>>();
    if (remoteResponses != null) {
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      res.data = [];
      res.data.add(
          EmailAvailableResponse.fromMap(remoteResponses[0].data));
      res.data.add(PhoneNumberAvailableResponse.fromMap(remoteResponses[1].data)
          );
      if (remoteResponses[0].statusCode == 200 &&
          remoteResponses[1].statusCode == 200)
        res.responseType = ResType.ResponseType.SUCCESS;
      else if (remoteResponses[0].statusCode == 400 ||
          remoteResponses[1].statusCode == 400 ||
          remoteResponses[0].statusCode == 401 ||
          remoteResponses[1].statusCode == 401)
        res.responseType = ResType.ResponseType.VALIDATION_ERROR;
      else if (remoteResponses[0].statusCode == 500 ||
          remoteResponses[1].statusCode == 500)
        res.responseType = ResType.ResponseType.SERVER_ERROR;
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  ResponseWrapper<String>
      _prepareRegisteredUserResponse(
          {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<String>();
   if (remoteResponse != null) {
      res.data = remoteResponse.data[AppConst.ENTITY];
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  
}
