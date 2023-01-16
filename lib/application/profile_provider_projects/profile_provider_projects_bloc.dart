import 'dart:async';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/expire_validation.dart';
import 'package:arachnoit/domain/profile_provider/issue_date_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/new_projects_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_projects/response/projects_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
part 'profile_provider_projects_event.dart';
part 'profile_provider_projects_state.dart';

const _postLimit = 20;

class ProfileProviderProjectsBloc
    extends Bloc<ProfileProviderProjectsEvent, ProfileProviderProjectsState> {
  final CatalogFacadeService catalogService;
  ProfileProviderProjectsBloc({this.catalogService}) : super(ProfileProviderProjectsState());

  @override
  Stream<Transition<ProfileProviderProjectsEvent, ProfileProviderProjectsState>> transformEvents(
    Stream<ProfileProviderProjectsEvent> events,
    TransitionFunction<ProfileProviderProjectsEvent, ProfileProviderProjectsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderProjectsState> mapEventToState(
    ProfileProviderProjectsEvent event,
  ) async* {
    if (event is GetAllProjects) {
      yield* _mapGetAllProjects(event, state);
    } else if (event is AddItemToFileList)
      yield AddItemToFileListState(file: event.file);
    else if (event is RemoveItemFromFileList)
      yield RemoveItemFromFileListState(index: event.index);
    else if (event is SetNewProject) {
      yield* _mapSetNewProject(event);
    } else if (event is UpdateSelectedProject) {
      yield* _mapUpdateSelectedProject(event);
    } else if (event is UpdateListAfterSuccess) {
      yield* _mapUpdateListAfterSuccess(event);
    } else if (event is DeleteProjectItem) {
      yield* _mapDeleteSelectedItem(event);
    }
  }

  Stream<ProfileProviderProjectsState> _mapDeleteSelectedItem(DeleteProjectItem event) async* {
    List<ProjectsResponse> item = state.posts;

    try {
      final response = await catalogService.deleteSeletecteProject(
        itemId: event.itemId,
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

  Stream<ProfileProviderProjectsState> _mapUpdateListAfterSuccess(
      UpdateListAfterSuccess event) async* {
    List<ProjectsResponse> item = state.posts;
    item[event.index].endDate = event.newItem.endDate;
    item[event.index].startDate = event.newItem.startDate;
    item[event.index].attachments = event.newItem.files;
    item[event.index].description = event.newItem.description;
    item[event.index].name = event.newItem.name;
    item[event.index].url = event.newItem.url;
    yield state.copyWith(posts: item);
  }

  Stream<ProfileProviderProjectsState> _mapUpdateSelectedProject(
      UpdateSelectedProject event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.description);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);

    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).projects_item_name,
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
          AppLocalizations.of(event.context).expire_date, event.context);
      yield InvalidState();
      return;
    }

    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).description,
          event.context);
      yield InvalidState();
      return;
    }
    List<ImageType> image = await GlobalPurposeFunctions.compressListOfImage(event.file);

    try {
      final response = await catalogService.updateSelectedProject(
        endDate: (event.withExpireTime) ? event.endDate : "",
        startDate: event.startDate,
        description: event.description,
        file: image,
        link: event.link,
        name: event.name,
        id: event.id,
        removedfiles: event.removedfiles,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessUpdateProjects(newProject: response.data);
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

  Stream<ProfileProviderProjectsState> _mapSetNewProject(SetNewProject event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.description);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);

    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).project_name,
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

    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              AppLocalizations.of(event.context).description,
          event.context);
      yield InvalidState();
      return;
    }
    List<ImageType> image = await GlobalPurposeFunctions.compressListOfImage(event.file);

    try {
      final response = await catalogService.setNewProject(
        endDate: event.endDate,
        startDate: event.startDate,
        description: event.description,
        file: image,
        link: event.link,
        name: event.name,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessAddNewProject();
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

  Stream<ProfileProviderProjectsState> _mapGetAllProjects(
      GetAllProjects event, ProfileProviderProjectsState state) async* {
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
        final posts = await _fetchGetAllProjects(event);
        yield state.copyWith(
          status: ProfileProviderStatus.success,
          posts: posts,
          hasReachedMax: _hasReachedMax(posts.length),
        );
        return;
      }
      final posts = await _fetchGetAllProjects(event, (state.posts.length / _postLimit).round());
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

  Future<List<ProjectsResponse>> _fetchGetAllProjects(GetAllProjects event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfilePrjects(
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
