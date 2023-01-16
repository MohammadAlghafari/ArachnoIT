import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/registration/response/account_types_response.dart';
import 'package:arachnoit/infrastructure/registration/response/cities_by_country_response.dart';
import 'package:arachnoit/infrastructure/registration/response/country_reponse.dart';
import 'package:arachnoit/infrastructure/common_response/specification_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_specification_response.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:arachnoit/infrastructure/search_provider/response/provider_services_response.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchProviderInterface {
  Future<ResponseWrapper<List<AccountTypesResponse>>> getAccountTypes();
  Future<ResponseWrapper<List<SpecificationResponse>>> getSpecification(
      {@required accountTypeId});
   Future<ResponseWrapper<List<SubSpecificationResponse>>> getSubSpecification({
    @required specificationId,
  });
  Future<ResponseWrapper<List<CountryResponse>>> getCountries();
    Future<ResponseWrapper<List<CitiesByCountryResponse>>> getCitiesByCountry({
    @required countryId,
  });
  Future<ResponseWrapper<List<AdvanceSearchResponse>>> setAdvanceSearchProvider();
  Future<ResponseWrapper<List<AdvanceSearchResponse>>> setSearchTextProvider();
  Future<ResponseWrapper<List<ProviderServicesResponse>>> getProviderServices();
  
}
