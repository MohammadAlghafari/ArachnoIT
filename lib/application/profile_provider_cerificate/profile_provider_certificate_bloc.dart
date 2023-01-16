import 'dart:async';
import 'dart:io';

import 'package:arachnoit/application/profile_provider/profile_provider_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/expire_validation.dart';
import 'package:arachnoit/domain/profile_provider/file_validation.dart';
import 'package:arachnoit/domain/profile_provider/issue_date_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/profile_provider_certificate/repository/certificate_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:rxdart/rxdart.dart';
import '../../infrastructure/profile_provider_certificate/repository/certificate_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../infrastructure/profile_provider_certificate/repository/new_certificate_response.dart';

part 'profile_provider_certificate_event.dart';
part 'profile_provider_certificate_state.dart';

const _postLimit = 20;

class ProfileProviderCertificateBloc
    extends Bloc<ProfileProviderCertificateEvent, ProfileProviderCertificateState> {
  CatalogFacadeService catalogService;
  ProfileProviderCertificateBloc({this.catalogService}) : super(ProfileProviderCertificateState());
  @override
  Stream<Transition<ProfileProviderCertificateEvent, ProfileProviderCertificateState>>
      transformEvents(
    Stream<ProfileProviderCertificateEvent> events,
    TransitionFunction<ProfileProviderCertificateEvent, ProfileProviderCertificateState>
        transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 200)),
      transitionFn,
    );
  }

  @override
  Stream<ProfileProviderCertificateState> mapEventToState(
    ProfileProviderCertificateEvent event,
  ) async* {
    if (event is GetAllCertificate) {
      yield* _mapGetAllCertificate(event, state);
    } else if (event is AddNewCertificate) {
      yield* _mapProfileProviderLicensesEvent(event);
    } else if (event is ChangeTheFileImagePath)
      yield* _mapChangeTheFileImagePath(event);
    else if (event is ChangeNoEndDateTimeValue)
      yield NewEndDateTimeState(state: event.value);
    else if (event is UpdateSelectedCertificate)
      yield* _mapUpdateCertificate(event);
    else if (event is UpdateSelectedLicenseAfterSuccessRequest)
      yield* _maphandleUpdate(event);
    else if (event is DeleteCertificateEvent) yield* _mapDeleteCertificateEvent(event);
  }

  Stream<ProfileProviderCertificateState> _mapDeleteCertificateEvent(
      DeleteCertificateEvent event) async* {
    try {
      final response = await catalogService.deleteCertificate(itemId: event.typeId);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        List<CertificateResponse> item = state.posts;
        item.removeAt(event.index);
        yield state.copyWith(posts: item, status: ProfileProviderStatus.deleteItemSuccess);
        return;
      } else {
        yield state.copyWith(
            posts: state.posts,
            status: ProfileProviderStatus.invalid,
            errosMessage: AppLocalizations.of(event.context).check_your_internet_connection);
        return;
      }
    } catch (_) {
      yield state.copyWith(
          posts: state.posts,
          status: ProfileProviderStatus.invalid,
          errosMessage: AppLocalizations.of(event.context).check_your_internet_connection);
    }
  }

  Stream<ProfileProviderCertificateState> _maphandleUpdate(
      UpdateSelectedLicenseAfterSuccessRequest event) async* {
    CertificateResponse certificate = state.posts[event.index];
    certificate.name = event.certificate.name;
    certificate.organization = event.certificate.organization;
    certificate.issueDate = event.certificate.issueDate;
    certificate.expirationDate = event.certificate.expirationDate;
    certificate.url = event.certificate.url;
    certificate.attachments = event.certificate.files;
    state.posts[event.index] = certificate;
    yield state.copyWith(posts: state.posts, status: ProfileProviderStatus.success);
  }

  Stream<ProfileProviderCertificateState> _mapUpdateCertificate(
      UpdateSelectedCertificate event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.organization);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.issueDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.expirationDate);
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
    File image = await GlobalPurposeFunctions.compressImage(event.file);
    try {
      final response = await catalogService.updateCertificate(
          expirationDate: (event.withExpireTime) ? "" : event.expirationDate,
          file: image,
          issueDate: event.issueDate,
          name: event.name,
          organization: event.organization,
          url: event.url,
          id: event.id,
          removedfiles: event.removedfiles);
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SucceessUpdateCertificate(newResponse: response.data);
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

  Stream<ProfileProviderCertificateState> _mapChangeTheFileImagePath(
      ChangeTheFileImagePath event) async* {
    String file = event.file.path;
    bool isImage = GlobalPurposeFunctions.fileTypeIsImage(filePath: file);
    yield ChangeFileSuccess(file: event.file, fileIsImage: isImage);
  }

  Stream<ProfileProviderCertificateState> _mapProfileProviderLicensesEvent(
      AddNewCertificate event) async* {
    TitleValidation titleCertificate = TitleValidation.dirty(event.name);
    EnterpriseValidation enterpriseCertificate = EnterpriseValidation.dirty(event.organization);
    IssueDateValidation issueDate = IssueDateValidation.dirty(event.issueDate);
    ExpireDateValidation expireDate = ExpireDateValidation.dirty(event.expirationDate);
    String stringFile = "";
    if (event.file != null) stringFile = event.file.toString();
    FilesValidation filesCertificate = FilesValidation.dirty(stringFile);
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
    // fomzState = Formz.validate([issueDate]);
    // if (fomzState.isInvalid) {
    //   GlobalPurposeFunctions.showToast("enter issueDate", event.context);
    //   yield InvalidState();
    //   return;
    // }
    // fomzState = Formz.validate([expireDate]);
    // if (fomzState.isInvalid && event.withExpireTime) {
    //   GlobalPurposeFunctions.showToast("enter expireDate", event.context);
    //   yield InvalidState();
    //   return;
    // }
    fomzState = Formz.validate([filesCertificate]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(AppLocalizations.of(event.context).add_file, event.context);
      yield InvalidState();
      return;
    }
    File image = await GlobalPurposeFunctions.compressImage(event.file);

    try {
      final response = await catalogService.addNewCertificate(
        expirationDate: DateTime.now().toString(),
        file: image,
        issueDate: DateTime.now().toString(),
        name: event.name,
        organization: event.organization,
        url: event.url,
      );
      if (response.responseType == ResType.ResponseType.SUCCESS) {
        yield SucceessAddNewCertificate();
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

  Stream<ProfileProviderCertificateState> _mapGetAllCertificate(
      GetAllCertificate event, ProfileProviderCertificateState state) async* {
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

  Future<List<CertificateResponse>> _fetchAdvanceSearchGroup(GetAllCertificate event,
      [int startIndex = 0]) async {
    try {
      final response = await catalogService.getProfileCertificate(
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
