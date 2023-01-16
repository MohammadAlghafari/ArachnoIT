import 'dart:async';

import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/expire_validation.dart';
import 'package:arachnoit/domain/profile_provider/issue_date_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/new_skill_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_skill/repository/skills_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
part 'profile_provider_skills_event.dart';
part 'profile_provider_skills_state.dart';

const _postLimit = 20;

class ProfileProviderSkillsBloc
    extends Bloc<ProfileProviderSkillsEvent, ProfileProviderSkillsState> {
  CatalogFacadeService catalogService;
  ProfileProviderSkillsBloc({this.catalogService}) : super(ProfileProviderSkillsState());
  @override
  Stream<Transition<ProfileProviderSkillsEvent, ProfileProviderSkillsState>> transformEvents(
    Stream<ProfileProviderSkillsEvent> events,
    TransitionFunction<ProfileProviderSkillsEvent, ProfileProviderSkillsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderSkillsState> mapEventToState(ProfileProviderSkillsEvent event) async* {
    if (event is GetAllSkills) {
      yield* _mapGetAllLectures(event, state);
    } else if (event is AddNewSkill) {
      yield* _mapAddNewSkill(event);
    } else if (event is UpdateSkill) {
      yield* _mapUpdateSkill(event);
    } else if (event is UpdateValueAfterSuccess) {
      yield* _mapUpdateValueAfterSuccess(event);
    } else if (event is DeleteSelectedSkill) {
      yield* _mapDeleteSelectedItem(event);
    }
  }

  Stream<ProfileProviderSkillsState> _mapDeleteSelectedItem(DeleteSelectedSkill event) async* {
    List<SkillsResponse> item = state.posts;

    try {
      final response = await catalogService.deleteSelectedSkill(
        itemID: event.itemId,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        item.removeAt(event.index);
        yield state.copyWith(posts: item, status: ProfileProviderStatus.deleteItemSuccess);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);
        yield state.copyWith(posts: item, status: ProfileProviderStatus.failedDelete);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield state.copyWith(posts: item, status: ProfileProviderStatus.failedDelete);
    }
  }

  Stream<ProfileProviderSkillsState> _mapUpdateValueAfterSuccess(
      UpdateValueAfterSuccess event) async* {
    List<SkillsResponse> item = state.posts;
    item[event.index].endDate = event.skillResponse.endDate;
    item[event.index].startDate = event.skillResponse.startDate;
    item[event.index].description = event.skillResponse.description;
    item[event.index].name = event.skillResponse.name;
    yield state.copyWith(posts: item);
  }

  Stream<ProfileProviderSkillsState> _mapUpdateSkill(UpdateSkill event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.description);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);

    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_title, event.context);
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
          AppLocalizations.of(event.context).expire_date, event.context);
      yield InvalidState();
      return;
    }

    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_description, event.context);
      yield InvalidState();
      return;
    }

    try {
      final response = await catalogService.setNewSkill(
        endDate: (event.withExpireTime) ? event.endDate : "",
        startDate: event.startDate,
        description: event.description,
        name: event.name,
        itemId: event.itemId,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessUpdateSkill(newSkill: response.data);
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);
        yield ErrorState(
            errorMessage: response.errorMessage ??
                AppLocalizations.of(event.context).check_your_internet_connection);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderSkillsState> _mapAddNewSkill(AddNewSkill event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.description);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);

    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(AppLocalizations.of(event.context).jop_title, event.context);
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
          AppLocalizations.of(event.context).expire_date, event.context);
      yield InvalidState();
      return;
    }

    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_description, event.context);
      yield InvalidState();
      return;
    }

    try {
      final response = await catalogService.setNewSkill(
        endDate: (event.withExpireTime) ? event.endDate : "",
        startDate: event.startDate,
        description: event.description,
        name: event.name,
        itemId: "",
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessAddNewSkill();
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection, event.context);
        yield ErrorState(
            errorMessage: response.errorMessage ??
                AppLocalizations.of(event.context).check_your_internet_connection);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection, event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderSkillsState> _mapGetAllLectures(
      GetAllSkills event, ProfileProviderSkillsState state) async* {
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

  Future<List<SkillsResponse>> _fetchAdvanceSearchGroup(GetAllSkills event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfileSkills(
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
