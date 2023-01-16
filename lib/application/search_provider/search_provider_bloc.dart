import 'dart:async';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/search_provider/search_provider_city_by_country.dart';
import 'package:arachnoit/domain/search_provider/search_provider_specification.dart';
import 'package:arachnoit/domain/search_provider/search_provider_sub_specification.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/registration/response/cities_by_country_response.dart';
import 'package:arachnoit/infrastructure/registration/response/country_reponse.dart';
import 'package:arachnoit/infrastructure/common_response/specification_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_specification_response.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:arachnoit/infrastructure/search_provider/response/provider_services_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/registration/response/account_types_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'search_provider_event.dart';
part 'search_provider_state.dart';

const _postLimit = 20;

class SearchProviderBloc
    extends Bloc<SearchProviderEvent, SearchProviderState> {
  CatalogFacadeService catalogService;
  SearchProviderBloc({this.catalogService})
      : assert(catalogService != null),
        super(SearchProviderState());

  @override
  Stream<Transition<SearchProviderEvent, SearchProviderState>> transformEvents(
    Stream<SearchProviderEvent> events,
    TransitionFunction<SearchProviderEvent, SearchProviderState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<SearchProviderState> mapEventToState(
      SearchProviderEvent event) async* {
    if (event is GetAccountTypeEvent) {
      yield* _mapGetAccountTypeEvent(event);
    } else if (event is ChangeAccountTypeCheckValue) {
      yield* _mapChangeAccountTypeCheckValue(event, state);
    } else if (event is GetAllSpecificationEvent) {
      yield* _mapSpecificationToState(state, event);
    } else if (event is ShowSubSpecificationEvent) {
      yield* _mapShowSubSpecificationEvent(event);
    } else if (event is GetALlCountryEvent) {
      yield* _mapGetALlCountryEvent();
    } else if (event is GetAllCityByCountryEvent) {
      yield* _mapCitiesByCountryToState(event);
    } else if (event is ChangeGenderTypeEvent) {
      yield* _mapChangeGenderTypeEvent(event);
    } else if (event is FetchAdvanceSearchProvider) {
      yield* _mapAdvancedSearchBlogsFetchToState(state, event);
    } else if (event is FetchSearchTextProvider) {
      yield* _mapSearchTextBlogsFetchToState(state, event);
    } else if (event is FetchProviderServices) {
      yield* _mapFetchProviderServices(event);
    } else if (event is ResetAdvanceSearchValues)
      yield ResetAdvanceSearchValuesState();
    else if (event is GetProfile) {
      yield* _mapGetProfile(event);
    }
  }

  Stream<SearchProviderState> _mapGetProfile(GetProfile event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<BriefProfileResponse> briefProfileResponse =
          await catalogService.getCommentBriefProfile(id: event.userId);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (briefProfileResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetBriedProfileSuceess(profileInfo: briefProfileResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(
            remoteClientErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteClientErrorState(remoteClientErrorMessage: "");
    }
  }

  Stream<SearchProviderState> _mapFetchProviderServices(
      FetchProviderServices event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<ProviderServicesResponse>>
          accountTypesResponse = await catalogService.getProviderServices();
      switch (accountTypesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield FetchProviderServicesSuccess(
              servicesList: accountTypesResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: accountTypesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: accountTypesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<SearchProviderState> _mapSearchTextBlogsFetchToState(
    SearchProviderState state,
    FetchSearchTextProvider event,
  ) async* {
    if (event.newRequest) {
      state = state.copyWith(
        hasReachedMax: false,
        posts: [],
        status: BlogSearchProviderStatus.initial,
      );
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == BlogSearchProviderStatus.initial) {
        yield state.copyWith(
          status: BlogSearchProviderStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchSearchTextProviderPosts(
          event.query,
        );
        yield state.copyWith(
          status: BlogSearchProviderStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchSearchTextProviderPosts(
          event.query, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BlogSearchProviderStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: BlogSearchProviderStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<AdvanceSearchResponse>> _fetchSearchTextProviderPosts(
      String query,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getTextSearchProvider(
          pageNumber: startIndex, pageSize: _postLimit, query: query);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching posts');
    } catch (e) {}
  }

  Stream<SearchProviderState> _mapAdvancedSearchBlogsFetchToState(
    SearchProviderState state,
    FetchAdvanceSearchProvider event,
  ) async* {
    if (event.newRequest) {
      state = state.copyWith(
        hasReachedMax: false,
        posts: [],
        status: BlogSearchProviderStatus.initial,
      );
      yield state;
    }
    if (state.hasReachedMax) {
      yield state;
      return;
    }
    try {
      if (state.status == BlogSearchProviderStatus.initial) {
        yield state.copyWith(
          status: BlogSearchProviderStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchAdvancedSearchBlogPosts(event);
        yield state.copyWith(
          status: BlogSearchProviderStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvancedSearchBlogPosts(
          event, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: BlogSearchProviderStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: BlogSearchProviderStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<AdvanceSearchResponse>> _fetchAdvancedSearchBlogPosts(
      FetchAdvanceSearchProvider event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getSeacrchProviderAdvanceSearch(
          pageNumber: startIndex,
          pageSize: _postLimit,
          accountTypeId: event.accountTypeId,
          cityId: event.cityId,
          countryId: event.countryId,
          gender: event.gender,
          serviceId: event.serviceId,
          specificationsIds: event.specificationsIds,
          subSpecificationId: event.subSpecificationId);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching posts');
    } catch (e) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;

  Stream<SearchProviderState> _mapChangeGenderTypeEvent(
      ChangeGenderTypeEvent event) async* {
    print("the gender Type is ${event.genderId}");
    yield ChangeMaleTypeSuccessState(genderId: event.genderId);
  }

  Stream<SearchProviderState> _mapCitiesByCountryToState(
      GetAllCityByCountryEvent event) async* {
    SearchProviderCityByProvider searchProviderCityByProvider =
        SearchProviderCityByProvider.dirty(event.countryId);
    final fomzState = Formz.validate([searchProviderCityByProvider]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
        AppLocalizations.of(event.context).choose_your_country_first,
        event.context,
      );
      yield InvalidState();
    } else {
      try {
        yield LoadingState();
        final ResponseWrapper<List<CitiesByCountryResponse>> citiesByCountry =
            await catalogService.getSearchProviderCitiesByCountry(
                countryId: event.countryId);
        switch (citiesByCountry.responseType) {
          case ResType.ResponseType.SUCCESS:
            yield GetAllCitiesByCountrySuccessState(
                citiesList: citiesByCountry.data);
            break;
          case ResType.ResponseType.VALIDATION_ERROR:
            yield RemoteValidationErrorState(
              remoteValidationErrorMessage: citiesByCountry.errorMessage,
            );
            break;
          case ResType.ResponseType.SERVER_ERROR:
            yield RemoteServerErrorState(
              remoteServerErrorMessage: citiesByCountry.errorMessage,
            );
            break;
          case ResType.ResponseType.CLIENT_ERROR:
            yield RemoteClientErrorState();
            break;
          case ResType.ResponseType.NETWORK_ERROR:
            break;
        }
      } catch (e) {
        yield RemoteClientErrorState();
        return;
      }
    }
  }

  Stream<SearchProviderState> _mapGetALlCountryEvent() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<CountryResponse>> countriesResponse =
          await catalogService.getCountries();
      switch (countriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAllCountriesState(
            countriesList: countriesResponse.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: countriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: countriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<SearchProviderState> _mapShowSubSpecificationEvent(
      ShowSubSpecificationEvent event) async* {
    SearchProviderSubSpecification searchProviderSubSpecification =
        SearchProviderSubSpecification.dirty(event.specificationId);
    final fomzState = Formz.validate([searchProviderSubSpecification]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
        AppLocalizations.of(event.context).please_add +
            " " +
            AppLocalizations.of(event.context).type,
        event.context,
      );
      yield InvalidState();
    } else {
      try {
        yield LoadingState();
        final ResponseWrapper<List<SubSpecificationResponse>>
            subSpecificationResponse =
            await catalogService.getSearchProviderSubSpecification(
          specificationId: event.specificationId,
        );
        switch (subSpecificationResponse.responseType) {
          case ResType.ResponseType.SUCCESS:
            yield ShowSubSpecificationState(
              subSpecificationList: subSpecificationResponse.data,
            );
            break;
          case ResType.ResponseType.VALIDATION_ERROR:
            yield RemoteValidationErrorState(
              remoteValidationErrorMessage:
                  subSpecificationResponse.errorMessage,
            );
            break;
          case ResType.ResponseType.SERVER_ERROR:
            yield RemoteServerErrorState(
              remoteServerErrorMessage: subSpecificationResponse.errorMessage,
            );
            break;
          case ResType.ResponseType.CLIENT_ERROR:
            yield RemoteClientErrorState();
            break;
          case ResType.ResponseType.NETWORK_ERROR:
            break;
        }
      } catch (e) {
        yield RemoteClientErrorState();
        return;
      }
    }
  }

  Stream<SearchProviderState> _mapSpecificationToState(
      SearchProviderState state, GetAllSpecificationEvent event) async* {
    SearchProviderSpecification searchProviderSpecification =
        SearchProviderSpecification.dirty(event.accountTypeId);
    final fomzState = Formz.validate([searchProviderSpecification]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
        AppLocalizations.of(event.context).choose_account_type,
        event.context,
      );
      yield InvalidState();
    } else {
      try {
        yield LoadingState();
        final ResponseWrapper<List<SpecificationResponse>>
            specificationResponse = await catalogService.getSpecification(
                accountTypeId: event.accountTypeId);
        switch (specificationResponse.responseType) {
          case ResType.ResponseType.SUCCESS:
            yield GetSpecificationSuccessState(
                specificationItems: specificationResponse.data);
            break;
          case ResType.ResponseType.VALIDATION_ERROR:
            yield RemoteValidationErrorState(
              remoteValidationErrorMessage: specificationResponse.errorMessage,
            );
            break;
          case ResType.ResponseType.SERVER_ERROR:
            yield RemoteServerErrorState(
              remoteServerErrorMessage: specificationResponse.errorMessage,
            );
            break;
          case ResType.ResponseType.CLIENT_ERROR:
            yield RemoteClientErrorState();
            break;
          case ResType.ResponseType.NETWORK_ERROR:
            break;
        }
      } catch (e) {
        yield RemoteClientErrorState();
        return;
      }
    }
  }

  Stream<SearchProviderState> _mapChangeAccountTypeCheckValue(
      ChangeAccountTypeCheckValue event, SearchProviderState state) async* {
    yield ChangeAccountTypeState(selectedIndex: event.checkValue);
  }

  Stream<SearchProviderState> _mapGetAccountTypeEvent(
      GetAccountTypeEvent event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<AccountTypesResponse>> accountTypesResponse =
          await catalogService.getSearchProviderAccountTypes();
      switch (accountTypesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAccountTypeSuccessState(
              accountTypeList: accountTypesResponse.data,
              changeValueIndex: event.index);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: accountTypesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: accountTypesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      yield RemoteClientErrorState();
      return;
    }
  }
}
