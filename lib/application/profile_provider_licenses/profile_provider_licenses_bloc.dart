import 'dart:async';
import 'dart:io';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/profile_provider/description_validation.dart';
import 'package:arachnoit/domain/profile_provider/file_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/licenses_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_licenses/response/new_license_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'profile_provider_licenses_event.dart';
part 'profile_provider_licenses_state.dart';

const _postLimit = 20;

class ProfileProviderLicensesBloc
    extends Bloc<ProfileProviderLicensesEvent, ProfileProviderLicensesState> {
  CatalogFacadeService catalogService;
  ProfileProviderLicensesBloc({this.catalogService})
      : super(ProfileProviderLicensesState());

  @override
  Stream<Transition<ProfileProviderLicensesEvent, ProfileProviderLicensesState>>
      transformEvents(
    Stream<ProfileProviderLicensesEvent> events,
    TransitionFunction<ProfileProviderLicensesEvent,
            ProfileProviderLicensesState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderLicensesState> mapEventToState(
      ProfileProviderLicensesEvent event) async* {
    if (event is GetAllLicenses) {
      yield* _mapGetAllLectures(event, state);
    } else if (event is ChangeTheFileImagePath) {
      yield* _mapChangeTheFileImagePath(event);
    } else if (event is AddNewLicense) {
      yield* _mapAddNewLicense(event);
    } else if (event is UpdateLicense) {
      yield* _mapUpdateLicense(event);
    } else if (event is UpdateSelectedLicenseAfterSuccessRequest) {
      yield* _mapUpdate(event);
    } else if (event is DeleteLicenseEvent)
      yield* _mapDeleteExperianceEvent(event);
  }

  Stream<ProfileProviderLicensesState> _mapDeleteExperianceEvent(
      DeleteLicenseEvent event) async* {
    try {
      final response = await catalogService.deleteLicense(itemId: event.typeId);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        List<LicensesResponse> item = state.posts;
        item.removeAt(event.index);
        yield state.copyWith(
            posts: item, status: ProfileProviderStatus.deleteItemSuccess);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection,
            event.context);
        yield state.copyWith(status: ProfileProviderStatus.failedDelete);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      yield state.copyWith(status: ProfileProviderStatus.failedDelete);
    }
  }

  Stream<ProfileProviderLicensesState> _mapUpdate(
      UpdateSelectedLicenseAfterSuccessRequest event) async* {
    LicensesResponse licensesResponse = state.posts[event.index];
    licensesResponse.description = event.license.description;
    licensesResponse.title = event.license.title;
    licensesResponse.fileUrl = event.license.fileDto.url;
    state.posts[event.index] = licensesResponse;
    yield state.copyWith(
        posts: state.posts, status: ProfileProviderStatus.success);
  }

//AppLocalizations.of(context).
  Stream<ProfileProviderLicensesState> _mapUpdateLicense(
      UpdateLicense event) async* {
    DescriptionValidation descriptionLicense =
        DescriptionValidation.dirty(event.description);
    TitleValidation addNewLicense = TitleValidation.dirty(event.title);
    FormzStatus fomzState = Formz.validate([addNewLicense]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_title, event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([descriptionLicense]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_description,
          event.context);
      yield InvalidState();
      return;
    }
    try {
      File image = await GlobalPurposeFunctions.compressImage(event.file);
      final response = await catalogService.updateProfileLicense(
        description: event.description,
        file: image,
        id: event.id,
        title: event.title,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessUpdateProfile(license: response.data);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection,
            event.context);
        yield ErrorState(errosState: response.errorMessage);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderLicensesState> _mapAddNewLicense(
      AddNewLicense event) async* {
    DescriptionValidation descriptionLicense =
        DescriptionValidation.dirty(event.description);
    TitleValidation addNewLicense = TitleValidation.dirty(event.title);
    String stringFile = "";
    if (event.file != null) stringFile = event.file.toString();
    FilesValidation fileLicense = FilesValidation.dirty(stringFile);
    FormzStatus fomzState = Formz.validate([addNewLicense]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_title, event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([descriptionLicense]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_description,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([fileLicense]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_file, event.context);
      yield InvalidState();
      return;
    }
    try {
      File image = await GlobalPurposeFunctions.compressImage(event.file);
      final response = await catalogService.setProfileLicense(
        description: event.description,
        file: image,
        title: event.title,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        print("the response is ${response.data.title}");
        yield AddLicenseSuccess(license: response.data);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection,
            event.context);
        yield ErrorState(errosState: response.errorMessage);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderLicensesState> _mapChangeTheFileImagePath(
      ChangeTheFileImagePath event) async* {
    yield ChangeFileSuccess();
  }

  Stream<ProfileProviderLicensesState> _mapGetAllLectures(
      GetAllLicenses event, ProfileProviderLicensesState state) async* {
    if (state.hasReachedMax&&!event.newRequest) {
      yield state;
      return;
    }
    try {
      if (state.status == ProfileProviderStatus.initial||event.newRequest) {
        yield state.copyWith(
          status: ProfileProviderStatus.loading,
          posts: state.posts,
          hasReachedMax: state.hasReachedMax,
        );
        state.copyWith();
        final posts = await _fetchAdvanceSearchGroup(event);
        yield state.copyWith(
          status: ProfileProviderStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchAdvanceSearchGroup(
          event, (state.posts.length / _postLimit).round());
      yield posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: ProfileProviderStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: _hasReachedMax(posts.length),
            );
    } catch (e) {
      yield state.copyWith(status: ProfileProviderStatus.failure);
      return;
    }
  }

  Future<List<LicensesResponse>> _fetchAdvanceSearchGroup(GetAllLicenses event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfileLicense(
        healthcareProviderId: event.userId,
        pageNumber: startIndex,
        pageSize: _postLimit,
      );
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
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
