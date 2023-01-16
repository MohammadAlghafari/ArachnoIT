import 'dart:async';
import 'dart:io';

import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/expire_validation.dart';
import 'package:arachnoit/domain/profile_provider/issue_date_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/profile_provider_experiance/response/experiance_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/profile_provider_experiance/response/experiance_response.dart';
import '../../infrastructure/profile_provider_experiance/response/new_experiance_response.dart';
part 'profile_provider_experiance_event.dart';
part 'profile_provider_experiance_state.dart';

const _postLimit = 20;

class ProfileProviderExperianceBloc
    extends Bloc<ProfileProviderExperianceEvent, ProfileProviderExperianceState> {
  CatalogFacadeService catalogService;
  ProfileProviderExperianceBloc({this.catalogService}) : super(ProfileProviderExperianceState());
  @override
  Stream<Transition<ProfileProviderExperianceEvent, ProfileProviderExperianceState>>
      transformEvents(
    Stream<ProfileProviderExperianceEvent> events,
    TransitionFunction<ProfileProviderExperianceEvent, ProfileProviderExperianceState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderExperianceState> mapEventToState(
      ProfileProviderExperianceEvent event) async* {
    if (event is GetALlExperiance) {
      yield* _mapGetAllCertificate(event, state);
    } else if (event is AddItemToFileList)
      yield AddItemToFileListState(file: event.file);
    else if (event is RemoveItemFromFileList)
      yield RemoveItemFromFileListState(index: event.index);
    else if (event is AddNewExperiance) {
      yield* _mapProfileProviderLicensesEvent(event);
    } else if (event is UpdateExperianceEvent) {
      yield* _mapUpdateExperiance(event);
    } else if (event is UpdateInfoAfterSuccess) {
      yield* _mapUpdateInfoAfterSuccess(event, state);
    } else if (event is DeleteExperianceEvent) {
      yield* _mapDeleteExperianceEvent(event);
    }
  }

  Stream<ProfileProviderExperianceState> _mapDeleteExperianceEvent(
      DeleteExperianceEvent event) async* {
    try {
      final response = await catalogService.deleteExperiance(itemId: event.typeId);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        List<ExperianceResponse> item = state.posts;
        item.removeAt(event.index);
        yield state.copyWith(posts: item, status: ProfileProviderStatus.deleteItemSuccess);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);

        yield state.copyWith(status: ProfileProviderStatus.failedDelete);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield state.copyWith(status: ProfileProviderStatus.failedDelete);
    }
  }

  Stream<ProfileProviderExperianceState> _mapUpdateInfoAfterSuccess(
      UpdateInfoAfterSuccess event, ProfileProviderExperianceState state) async* {
    ExperianceResponse val = state.posts[event.index];
    val.title = event.response.title;
    val.startDate = event.response.startDate;
    val.endDate = event.response.endDate;
    val.link = event.response.link;
    val.description = event.response.description;
    val.company = event.response.company;
    val.attachments = event.response.files;
    val.isValid = event.response.isValid;
    state.posts[event.index] = val;
    yield state.copyWith(posts: state.posts, status: ProfileProviderStatus.success);
  }

  Stream<ProfileProviderExperianceState> _mapUpdateExperiance(UpdateExperianceEvent event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.organization);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).jop_title,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).company,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([issueDate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).start_date, event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([expireDate]);
    if (fomzState.isInvalid && event.withExpireTime) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_end_time, event.context);
      yield InvalidState();
      return;
    }
    List<ImageType> image = await GlobalPurposeFunctions.compressListOfImage(event.file);

    try {
      final response = await catalogService.updateExperiance(
        description: event.description,
        endDate: (event.withExpireTime) ? event.endDate : "",
        file: image,
        name: event.name,
        organization: event.organization,
        startDate: event.startDate,
        url: event.url,
        id: event.id,
        removedFiles: event.removedFiles,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessUpdateExperiance(newExperianceResponse: response.data);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);
        yield InvalidState();
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderExperianceState> _mapProfileProviderLicensesEvent(
      AddNewExperiance event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.organization);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              AppLocalizations.of(event.context).jop_title,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              AppLocalizations.of(event.context).company,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([issueDate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).start_date, event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([expireDate]);
    if (fomzState.isInvalid && event.withExpireTime) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_end_time, event.context);
      yield InvalidState();
      return;
    }
    List<ImageType> image = await GlobalPurposeFunctions.compressListOfImage(event.file);

    try {
      final response = await catalogService.addNewExperiance(
          description: event.description,
          endDate: (event.withExpireTime) ? event.endDate : "",
          file: image,
          name: event.name,
          organization: event.organization,
          startDate: event.startDate,
          url: event.url);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessAddNewExperiance();
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);
        yield InvalidState();
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderExperianceState> _mapGetAllCertificate(
      GetALlExperiance event, ProfileProviderExperianceState state) async* {
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
        state.copyWith();
        final posts = await _fetchAdvanceSearchGroup(event);
        yield state.copyWith(
          status: ProfileProviderStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts =
          await _fetchAdvanceSearchGroup(event, (state.posts.length / _postLimit).round());
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

  Future<List<ExperianceResponse>> _fetchAdvanceSearchGroup(GetALlExperiance event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfileExperiance(
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
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
