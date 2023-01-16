part of 'search_provider_bloc.dart';

abstract class SearchProviderEvent extends Equatable {
  const SearchProviderEvent();
  @override
  List<Object> get props => [];
}

class GetAccountTypeEvent extends SearchProviderEvent {
  final int index;
  GetAccountTypeEvent({this.index});
}

class ChangeAccountTypeCheckValue extends SearchProviderEvent {
  final int checkValue;
  final List<AccountTypesResponse> accountType;
  ChangeAccountTypeCheckValue({this.checkValue, this.accountType});
}

class GetAllSpecificationEvent extends SearchProviderEvent {
  final String accountTypeId;
  final BuildContext context;
  GetAllSpecificationEvent({this.accountTypeId, this.context});
}

class ShowSubSpecificationEvent extends SearchProviderEvent {
  final String specificationId;
  final BuildContext context;
  ShowSubSpecificationEvent({this.specificationId, this.context});
}

class GetALlCountryEvent extends SearchProviderEvent {}

class GetAllCityByCountryEvent extends SearchProviderEvent {
  final String countryId;
  final BuildContext context;
  GetAllCityByCountryEvent({this.countryId, this.context});
}

class ChangeGenderTypeEvent extends SearchProviderEvent {
  final int genderId;
  ChangeGenderTypeEvent({@required this.genderId});
}

class FetchAdvanceSearchProvider extends SearchProviderEvent {
  final String accountTypeId;
  final String cityId;
  final String countryId;
  final int gender;
  final String serviceId;
  final List<String> specificationsIds;
  final String subSpecificationId;
  final bool newRequest;
  FetchAdvanceSearchProvider({
    this.newRequest = true,
    this.accountTypeId = "",
    this.cityId = "",
    this.countryId = "",
    this.gender,
    this.serviceId = "",
    this.specificationsIds = const <String>[],
    this.subSpecificationId = "",
  });
}

class FetchSearchTextProvider extends SearchProviderEvent {
  final String query;
  final bool newRequest;
  FetchSearchTextProvider({this.query, this.newRequest});
}

class FetchProviderServices extends SearchProviderEvent {}

class ResetAdvanceSearchValues extends SearchProviderEvent {}


class GetProfile extends SearchProviderEvent {
  final String userId;
  final BuildContext context;
  GetProfile({this.userId,this.context});
}
