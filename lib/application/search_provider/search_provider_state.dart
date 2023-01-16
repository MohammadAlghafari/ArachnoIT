part of 'search_provider_bloc.dart';

enum BlogSearchProviderStatus { initial, loading, success, failure }

class SearchProviderState {
  final BlogSearchProviderStatus status;
  final List<AdvanceSearchResponse> posts;
  final bool hasReachedMax;

  const SearchProviderState({
    this.status = BlogSearchProviderStatus.initial,
    this.posts = const <AdvanceSearchResponse>[],
    this.hasReachedMax = false,
  });

  SearchProviderState copyWith({
    BlogSearchProviderStatus status,
    List<AdvanceSearchResponse> posts,
    bool hasReachedMax,
  }) {
    return SearchProviderState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class LoadingState extends SearchProviderState {}

class RemoteValidationErrorState extends SearchProviderState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends SearchProviderState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends SearchProviderState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class ChangeAccountTypeState extends SearchProviderState {
  final int selectedIndex;
  ChangeAccountTypeState({this.selectedIndex});
}

class GetAccountTypeSuccessState extends SearchProviderState {
  final List<AccountTypesResponse> accountTypeList;
  final int changeValueIndex;
  GetAccountTypeSuccessState(
      {@required this.accountTypeList, @required this.changeValueIndex});
}

class GetSpecificationSuccessState extends SearchProviderState {
  final List<SpecificationResponse> specificationItems;
  GetSpecificationSuccessState({this.specificationItems});
}

class ShowSubSpecificationState extends SearchProviderState {
  final List<SubSpecificationResponse> subSpecificationList;
  ShowSubSpecificationState({this.subSpecificationList});
}

class GetAllCountriesState extends SearchProviderState {
  List<CountryResponse> countriesList;
  GetAllCountriesState({this.countriesList});
}

class GetAllCitiesByCountrySuccessState extends SearchProviderState {
  List<CitiesByCountryResponse> citiesList;
  GetAllCitiesByCountrySuccessState({this.citiesList});
}

class ChangeMaleTypeSuccessState extends SearchProviderState {
  final int genderId;
  ChangeMaleTypeSuccessState({this.genderId});
}

class InvalidState extends SearchProviderState {}

class GetProviderAdvanceSearchSuccess extends SearchProviderState {
  List<AdvanceSearchResponse> advanceSearchItem;
  GetProviderAdvanceSearchSuccess({@required this.advanceSearchItem});
}

class FetchProviderServicesSuccess extends SearchProviderState {
  final List<ProviderServicesResponse> servicesList;
  FetchProviderServicesSuccess({this.servicesList});
}

class ResetAdvanceSearchValuesState extends SearchProviderState {}

class GetBriedProfileSuceess extends SearchProviderState {
  final BriefProfileResponse profileInfo;

  GetBriedProfileSuceess({this.profileInfo});
}
