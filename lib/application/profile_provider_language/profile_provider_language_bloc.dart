import 'dart:async';

import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/profile_provider/description_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/profile_provider_language/response/language_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
part 'profile_provider_language_event.dart';
part 'profile_provider_language_state.dart';

const _postLimit = 20;

class ProfileProviderLanguageBloc
    extends Bloc<ProfileProviderLanguageEvent, ProfileProviderLanguageState> {
  ProfileProviderLanguageBloc({this.catalogService}) : super(ProfileProviderLanguageState());
  CatalogFacadeService catalogService;
  @override
  Stream<Transition<ProfileProviderLanguageEvent, ProfileProviderLanguageState>> transformEvents(
    Stream<ProfileProviderLanguageEvent> events,
    TransitionFunction<ProfileProviderLanguageEvent, ProfileProviderLanguageState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderLanguageState> mapEventToState(ProfileProviderLanguageEvent event) async* {
    if (event is GetAllLanguage) {
      yield* _mapGetAllCertificate(event, state);
    } else if (event is AddNewLanguage) {
      yield* _mapAddNewLanguage(event);
    } else if (event is ShowLanguageLevel) {
      yield SuccessShowLevel();
    } else if (event is DeletetItem) {
      yield* _mapDeletetItem(event);
    } else if (event is UpdateListValue) {
      yield* _mapUpdateListValue(event);
    }
  }

  Stream<ProfileProviderLanguageState> _mapUpdateListValue(UpdateListValue event) async* {
    List<LanguageResponse> item = state.posts;
    item[event.index].languageLevel = event.level;
    yield state.copyWith(posts: item);
  }

  Stream<ProfileProviderLanguageState> _mapDeletetItem(DeletetItem event) async* {
    try {
      final response = await catalogService.deleteSelectedLanguage(itemId: event.itemId);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        List<LanguageResponse> _items = state.posts;
        _items.removeAt(event.index);
        yield state.copyWith(posts: _items, status: ProfileProviderStatus.deleteItemSuccess);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);
        yield state.copyWith(
            status: ProfileProviderStatus.failedDelete,
            errorMessage: AppLocalizations.of(event.context).check_your_internet_connection);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield state.copyWith(
          status: ProfileProviderStatus.failedDelete,
          errorMessage: AppLocalizations.of(event.context).check_your_internet_connection);
      return;
    }
  }

  Stream<ProfileProviderLanguageState> _mapAddNewLanguage(AddNewLanguage event) async* {
    DescriptionValidation languageId = DescriptionValidation.dirty(event.languageId);
    FormzStatus fomzState = Formz.validate([languageId]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_select_language, event.context);
      yield InvalidState();
      return;
    }
    if (event.languageLevel == -1) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_select_language_level, event.context);
      yield InvalidState();
      return;
    }
    try {
      final response = await catalogService.addNewLanguage(
        languageId: event.languageId,
        languageLevel: event.languageLevel,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessAddNewLanguage();
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);
        yield ErrorsState(errorMessage: response.errorMessage);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield ErrorsState(
          errorMessage: AppLocalizations.of(event.context).check_your_internet_connection);
      return;
    }
  }

  Stream<ProfileProviderLanguageState> _mapGetAllCertificate(
      GetAllLanguage event, ProfileProviderLanguageState state) async* {
    if (state.hasReachedMax && !event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == ProfileProviderStatus.initial || event.newRequest) {
        yield state.copyWith(
          status: ProfileProviderStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        final posts = await _fetchAdvanceSearchGroup(event.forHealthCareProvider, event);
        yield state.copyWith(
          status: ProfileProviderStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvanceSearchGroup(
          event.forHealthCareProvider, event, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: ProfileProviderStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield state.copyWith(status: ProfileProviderStatus.failure);
      return;
    }
  }

  Future<List<LanguageResponse>> _fetchAdvanceSearchGroup(bool withProviderID, GetAllLanguage event,
      [int startIndex = 0]) async {
    try {
      String healthcareProviderId = "";
      if (withProviderID == true) healthcareProviderId = event.userId;
      final response = await catalogService.getAllLanguage(
          pageNumber: 0,
          pageSize: 0,
          enablePagination: false,
          searchString: "",
          healthcareProviderId: healthcareProviderId);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
