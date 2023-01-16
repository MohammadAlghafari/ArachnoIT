import 'dart:async';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/new_lectures_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/qualifications_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:formz/formz.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
part 'profile_provider_lectures_event.dart';
part 'profile_provider_lectures_state.dart';

const _postLimit = 20;

class ProfileProviderLecturesBloc
    extends Bloc<ProfileProviderLecturesEvent, ProfileProviderLecturesState> {
  final CatalogFacadeService catalogService;

  ProfileProviderLecturesBloc({@required this.catalogService})
      : super(ProfileProviderLecturesState());

  @override
  Stream<Transition<ProfileProviderLecturesEvent, ProfileProviderLecturesState>>
      transformEvents(
    Stream<ProfileProviderLecturesEvent> events,
    TransitionFunction<ProfileProviderLecturesEvent,
            ProfileProviderLecturesState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderLecturesState> mapEventToState(
      ProfileProviderLecturesEvent event) async* {
    if (event is GetAllLectures)
      yield* _mapGetAllLectures(event, state);
    else if (event is AddItemToFileList)
      yield AddItemToFileListState(file: event.file);
    else if (event is RemoveItemFromFileList)
      yield RemoveItemFromFileListState(index: event.index);
    else if (event is AddNewLecturesState)
      yield* _mapAddNewLecturesState(event);
    else if (event is UpdateLecturesState)
      yield* _mapUpdateLecturesState(event);
    else if (event is UpdateValue) {
      yield* _mapUpdateValue(event);
    } else if (event is DeleteSelectedItem) {
      yield* _mapDeleteSelectedItem(event);
    }
  }

  Stream<ProfileProviderLecturesState> _mapDeleteSelectedItem(
      DeleteSelectedItem event) async* {
    try {
      final response =
          await catalogService.deleteSelectedLectures(itemId: event.itemId);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        List<QualificationsResponse> item = state.posts;
        item.removeAt(event.index);
        yield state.copyWith(status: ProfileProviderStatus.deleteItemSuccess, posts: item);
        return;
      } else {
        yield state.copyWith(status: ProfileProviderStatus.failedDelete);
        GlobalPurposeFunctions.showToast(AppLocalizations.of(event.context).check_your_internet_connection,event.context);
        return;
      }
    } catch (_) {
        GlobalPurposeFunctions.showToast(AppLocalizations.of(event.context).check_your_internet_connection,event.context);
      yield state.copyWith(status: ProfileProviderStatus.failedDelete);
    }
  }

  Stream<ProfileProviderLecturesState> _mapUpdateValue(
      UpdateValue event) async* {
    List<QualificationsResponse> item = state.posts;
    item[event.index].title = event.item.title;
    item[event.index].description = event.item.description;
    item[event.index].attachments = event.item.files;
    yield state.copyWith(posts: item);
  }

  Stream<ProfileProviderLecturesState> _mapUpdateLecturesState(
      UpdateLecturesState event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.title);
    EnterpriseValidation enterpriseCertificate =
        EnterpriseValidation.dirty(event.description);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_title, event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_company, event.context);
      yield InvalidState();
      return;
    }
    if (event.file.length == 0) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_file, event.context);
      yield InvalidState();
      return;
    }
    try {
      List<ImageType> image =
          await GlobalPurposeFunctions.compressListOfImage(event.file);

      final response = await catalogService.updateLectures(
          description: event.description,
          file: image,
          title: event.title,
          itemId: event.itemId,
          removedFile: event.removedFile);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessUpdateLectures(
          index: event.index,
          newItem: response.data,
        );
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection,
            event.context);
        yield InvalidState();
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderLecturesState> _mapAddNewLecturesState(
      AddNewLecturesState event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.title);
    EnterpriseValidation enterpriseCertificate =
        EnterpriseValidation.dirty(event.description);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add_title, event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).company, event.context);
      yield InvalidState();
      return;
    }
    if (event.file.length == 0) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_file, event.context);
      yield InvalidState();
      return;
    }
    try {
      List<ImageType> image =
          await GlobalPurposeFunctions.compressListOfImage(event.file);
      final response = await catalogService.setNewLectures(
        description: event.description,
        file: image,
        title: event.title,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessAddNewLectures();
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection,
            event.context);
        yield ErrorsState(errorMessage: response.errorMessage);
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      yield InvalidState();
    }
  }

  Stream<ProfileProviderLecturesState> _mapGetAllLectures(
      GetAllLectures event, ProfileProviderLecturesState state) async* {
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
              hasReachedMax: _hasReachedMax(posts.length));
    } catch (e) {
      yield state.copyWith(status: ProfileProviderStatus.failure);
      return;
    }
  }

  Future<List<QualificationsResponse>> _fetchAdvanceSearchGroup(
      GetAllLectures event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfileLecture(
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
