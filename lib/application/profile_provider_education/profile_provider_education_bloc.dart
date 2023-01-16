import 'dart:async';
import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/expire_validation.dart';
import 'package:arachnoit/domain/profile_provider/issue_date_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/profile_provider_educations/response/educations_response.dart';
import 'package:arachnoit/presentation/custom_widgets/show_one_file_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
import '../../infrastructure/profile_provider_educations/response/educations_response.dart';
import '../../infrastructure/profile_provider_educations/response/new_education_response.dart';
part 'profile_provider_education_event.dart';
part 'profile_provider_education_state.dart';

const _postLimit = 20;

class ProfileProviderEducationBloc
    extends Bloc<ProfileProviderEducationEvent, ProfileProviderEducationState> {
  final CatalogFacadeService catalogService;
  ProfileProviderEducationBloc({this.catalogService}) : super(ProfileProviderEducationState());

  @override
  Stream<Transition<ProfileProviderEducationEvent, ProfileProviderEducationState>> transformEvents(
    Stream<ProfileProviderEducationEvent> events,
    TransitionFunction<ProfileProviderEducationEvent, ProfileProviderEducationState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderEducationState> mapEventToState(
      ProfileProviderEducationEvent event) async* {
    if (event is GetAllEducation)
      yield* _mapGetAllEducation(event, state);
    else if (event is AddItemToFileList)
      yield AddItemToFileListState(file: event.file);
    else if (event is RemoveItemFromFileList)
      yield RemoveItemFromFileListState(index: event.index);
    else if (event is AddNewEducation) {
      yield* _mapAddNewEducation(event);
    } else if (event is UpdateEducation) {
      yield* _mapUpdateEducation(event);
    } else if (event is UpdateEducationList) {
      yield* _mapUpdateEducationList(event);
    } else if (event is DeleteEducationEvent) yield* _mapDeleteEducationEvent(event);
  }

  Stream<ProfileProviderEducationState> _mapDeleteEducationEvent(
      DeleteEducationEvent event) async* {
    try {
      final response = await catalogService.deleteEducation(itemId: event.typeId);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        List<EducationsResponse> item = state.posts;
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

  Stream<ProfileProviderEducationState> _mapUpdateEducationList(UpdateEducationList event) async* {
    EducationsResponse response = state.posts[event.index];
    response.attachments = event.educationResponse.files;
    response.degree = event.educationResponse.degree;
    response.endDate = event.educationResponse.endDate;
    response.fieldOfStudy = event.educationResponse.fieldOfStudy;
    response.grade = event.educationResponse.grade;
    response.isValid = event.educationResponse.isValid;
    response.link = event.educationResponse.link;
    response.school = event.educationResponse.school;
    response.startDate = event.educationResponse.startDate;
    state.posts[event.index] = response;
    yield state.copyWith(posts: state.posts, status: ProfileProviderStatus.success);
  }

  Stream<ProfileProviderEducationState> _mapUpdateEducation(UpdateEducation event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.fieldOfStudy);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.school);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).field_of_study,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).school,
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
      final response = await catalogService.updateEducations(
          endDate: (event.withExpireTime) ? event.endDate : '',
          startDate: event.startDate,
          description: event.description,
          fieldOfStudy: event.fieldOfStudy,
          file: image,
          grade: event.grade,
          link: event.link,
          school: event.school,
          id: event.id,
          removedFiles: event.removedFiles);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessUpdateValue(newEducationResponse: response.data);
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

  Stream<ProfileProviderEducationState> _mapAddNewEducation(AddNewEducation event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.fieldOfStudy);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.school);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.startDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.endDate);
    FormzStatus fomzState;
    fomzState = Formz.validate([titleCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).field_of_study,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([enterpriseCertificate]);
    if (fomzState.isInvalid) {
      //please_add
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).school,
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
      final response = await catalogService.addNewEducation(
        endDate: (event.withExpireTime) ? event.endDate : '',
        startDate: event.startDate,
        description: event.description,
        fieldOfStudy: event.fieldOfStudy,
        file: image,
        grade: event.grade,
        link: event.link,
        school: event.school,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SuccessAddNewEducations();

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

  Stream<ProfileProviderEducationState> _mapGetAllEducation(
      GetAllEducation event, ProfileProviderEducationState state) async* {
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
              hasReachedMax: _hasReachedMax(posts.length));
    } catch (e) {
      yield state.copyWith(status: ProfileProviderStatus.failure);
      return;
    }
  }

  Future<List<EducationsResponse>> _fetchAdvanceSearchGroup(GetAllEducation event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfileEducation(
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
