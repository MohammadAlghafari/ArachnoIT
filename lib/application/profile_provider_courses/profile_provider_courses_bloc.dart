import 'dart:async';

import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/expire_validation.dart';
import 'package:arachnoit/domain/profile_provider/issue_date_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/courses_response.dart';
import 'package:arachnoit/infrastructure/profile_provider_courses/response/new_course_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'profile_provider_courses_event.dart';
part 'profile_provider_courses_state.dart';

const _postLimit = 20;

class ProfileProviderCoursesBloc
    extends Bloc<ProfileProviderCoursesEvent, ProfileProviderCoursesState> {
  CatalogFacadeService catalogService;
  ProfileProviderCoursesBloc({this.catalogService})
      : super(ProfileProviderCoursesState());

  @override
  Stream<Transition<ProfileProviderCoursesEvent, ProfileProviderCoursesState>>
      transformEvents(
    Stream<ProfileProviderCoursesEvent> events,
    TransitionFunction<ProfileProviderCoursesEvent, ProfileProviderCoursesState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderCoursesState> mapEventToState(
      ProfileProviderCoursesEvent event) async* {
    if (event is GetAllCourses)
      yield* _mapGetAllcourses(event, state);
    else if (event is AddItemToFileList)
      yield AddItemToFileListState(file: event.file);
    else if (event is RemoveItemFromFileList)
      yield RemoveItemFromFileListState(index: event.index);
    else if (event is AddNewCourse)
      yield* _mapAddNewCourse(event);
    else if (event is UpdateSelectedCourse)
      yield* _mapUpdateSelectedCourse(event);
    else if (event is UpdateDataAfterSuccess)
      yield* _mapUpdateDataAfterSuccess(event);
    else if (event is DeleteCourseEvent) yield* _mapDeleteCourseEvent(event);
  }

  Stream<ProfileProviderCoursesState> _mapDeleteCourseEvent(
      DeleteCourseEvent event) async* {
    try {
      final response = await catalogService.deleteCourse(
        itemId: event.id,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        List<CoursesResponse> items = state.posts;
        items.removeAt(event.index);
        yield state.copyWith(
          posts: items,
          status: ProfileProviderStatus.deleteItemSuccess,
        );
        return;
      } else {
       GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
        yield state.copyWith(
          status: ProfileProviderStatus.failedDelete,
        );
        return;
      }
    } catch (_) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      yield state.copyWith(
        status: ProfileProviderStatus.failedDelete,
      );
    }
  }

  Stream<ProfileProviderCoursesState> _mapUpdateDataAfterSuccess(
      UpdateDataAfterSuccess event) async* {
    List<CoursesResponse> items = state.posts;
    items[event.index].attachments = event.newCourseResponse.attachments;
    items[event.index].name = event.newCourseResponse.name;
    items[event.index].date = event.newCourseResponse.date;
    items[event.index].place = event.newCourseResponse.place;
    yield state.copyWith(posts: items);
  }

  Stream<ProfileProviderCoursesState> _mapUpdateSelectedCourse(
      UpdateSelectedCourse event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate =
        EnterpriseValidation.dirty(event.place);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.date);
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
          AppLocalizations.of(event.context).please_select_location,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([issueDate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_start_time, event.context);
      yield InvalidState();
      return;
    }
    if (event.file.length == 0) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_end_time, event.context);
      yield InvalidState();
      return;
    }
    List<ImageType> image =
        await GlobalPurposeFunctions.compressListOfImage(event.file);

    try {
      final response = await catalogService.updateCourse(
          date: event.date,
          file: image,
          name: event.name,
          place: event.place,
          removedfiles: event.removedfiles,
          id: event.id);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessUpdateCourses(newCourseResponse: response.data);
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

  Stream<ProfileProviderCoursesState> _mapAddNewCourse(
      AddNewCourse event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate =
        EnterpriseValidation.dirty(event.place);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.date);
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
          AppLocalizations.of(event.context).please_select_location,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([issueDate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_start_time, event.context);
      yield InvalidState();
      return;
    }
    if (event.file.length == 0) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).add_file, event.context);
      yield InvalidState();
      return;
    }
    List<ImageType> image =await GlobalPurposeFunctions.compressListOfImage(event.file);
    try {
      final response = await catalogService.setNewCourse(
        date: event.date,
        file: image,
        name: event.name,
        place: event.place,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessAddNewItem();
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

  Stream<ProfileProviderCoursesState> _mapGetAllcourses(
      GetAllCourses event, ProfileProviderCoursesState state) async* {

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

  Future<List<CoursesResponse>> _fetchAdvanceSearchGroup(GetAllCourses event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfileCourses(
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
    }  catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _postLimit ? true : false;
}
