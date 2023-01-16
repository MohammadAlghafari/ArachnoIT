import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/registration/response/account_types_response.dart';
import 'package:arachnoit/infrastructure/registration/response/cities_by_country_response.dart';
import 'package:arachnoit/infrastructure/registration/response/country_reponse.dart';
import 'package:arachnoit/infrastructure/common_response/specification_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_specification_response.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_advance_search.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_account_type.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_cities_by_country.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_country.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_services.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_specification.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_sub_specification.dart';
import 'package:arachnoit/infrastructure/search_provider/caller/remote/search_provider_remote_get_text_search.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:arachnoit/infrastructure/search_provider/response/provider_services_response.dart';
import 'package:arachnoit/infrastructure/search_provider/search_provider_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;

class SearchProviderRepositories implements SearchProviderInterface {
  final SearchRemoteProviderGetAccount searchRemoteProviderGetAccount;
  final SearchProviderRemoteGetSpecification
      searchProviderRemoteGetSpecification;
  final SearchProviderRemoteGetSubSpecification
      searchProviderRemoteGetSubSpecification;
  final SearchProviderRemoteGetCountry searchProviderRemoteGetCountry;
  final SearchProviderRemoterGetCitiesByCountry
      searchProviderRemoterGetCitiesByCountry;
  final SearchRemoteProviderGetAdvanceSearch searchRemoteProviderAdvanceSearch;
  final SearchProviderRemoteGetTextSearch searchProviderRemoteGetTextSearch;
  final SearchProviderRemoteGetServices searchProviderRemoteGetServices;
  SearchProviderRepositories({
    @required this.searchRemoteProviderGetAccount,
    @required this.searchProviderRemoteGetSpecification,
    @required this.searchProviderRemoteGetSubSpecification,
    @required this.searchProviderRemoteGetCountry,
    @required this.searchProviderRemoterGetCitiesByCountry,
    @required this.searchRemoteProviderAdvanceSearch,
    @required this.searchProviderRemoteGetTextSearch,
    @required this.searchProviderRemoteGetServices,
  });
  @override
  Future<ResponseWrapper<List<AccountTypesResponse>>> getAccountTypes() async {
    try {
      Response response =
          await searchRemoteProviderGetAccount.getAccountTypes();
      return _prepareAccountTypesResponse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareAccountTypesResponse(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
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

  @override
  Future<ResponseWrapper<List<SpecificationResponse>>> getSpecification(
      {accountTypeId}) async {
    try {
      Response response = await searchProviderRemoteGetSpecification
          .getSpecification(accountTypeId: accountTypeId);
      return _prepareSpecificationResponse(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSpecificationResponse(remoteResponse: e.response);
    } catch (e) {
      return null;
    }
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

  @override
  Future<ResponseWrapper<List<SubSpecificationResponse>>> getSubSpecification(
      {specificationId}) async {
    try {
      Response response =
          await searchProviderRemoteGetSubSpecification.getSubSpecification(
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

  @override
  Future<ResponseWrapper<List<CountryResponse>>> getCountries() async {
    try {
      Response response = await searchProviderRemoteGetCountry.getCountries();
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

  @override
  Future<ResponseWrapper<List<CitiesByCountryResponse>>> getCitiesByCountry(
      {countryId}) async {
    try {
      Response response =
          await searchProviderRemoterGetCitiesByCountry.getCitiesByCountries(
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

  @override
  Future<ResponseWrapper<List<AdvanceSearchResponse>>> setAdvanceSearchProvider(
      {String accountTypeId = "",
      String cityId = "",
      String countryId = "",
      int gender,
      String serviceId = "",
      List<String> specificationsIds = const <String>[],
      String subSpecificationId = "",
      int pageNumber,
      int pageSize}) async {
    try {
      Response response =
          await searchRemoteProviderAdvanceSearch.getAdvanceSearchProvider(
              pageNumber: pageNumber,
              pageSize: pageSize,
              accountTypeId: accountTypeId,
              cityId: cityId,
              countryId: countryId,
              gender: gender,
              serviceId: serviceId,
              specificationsIds: specificationsIds,
              subSpecificationId: subSpecificationId);
      return _prepareAdvanceSearchProvider(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareAdvanceSearchProvider(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<AdvanceSearchResponse>> _prepareAdvanceSearchProvider(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<AdvanceSearchResponse>>();
    if (remoteResponse != null) {
      print("remoteResponse ${remoteResponse.statusCode}");
      res.data = (remoteResponse.data as List)
          .map((x) => AdvanceSearchResponse.fromJson(x))
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

  @override
  Future<ResponseWrapper<List<AdvanceSearchResponse>>> setSearchTextProvider({
    String searchText,
    int pageNumber,
    int pageSize,
  }) async {
    try {
      Response response =
          await searchProviderRemoteGetTextSearch.getSearchTextProvider(
              searchText: searchText,
              pageNumber: pageNumber,
              pageSize: pageSize);
      return _prepareTextSearchProvider(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareTextSearchProvider(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<AdvanceSearchResponse>> _prepareTextSearchProvider(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<AdvanceSearchResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => AdvanceSearchResponse.fromJson(x))
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

  @override
  Future<ResponseWrapper<List<ProviderServicesResponse>>>
      getProviderServices() async {
    try {
      Response response =
          await searchProviderRemoteGetServices.getSpecification();
      return _prepareGetProviderServices(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetProviderServices(
        remoteResponse: e.response,
      );
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<List<ProviderServicesResponse>> _prepareGetProviderServices(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<ProviderServicesResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => ProviderServicesResponse.fromJson(x))
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
}
