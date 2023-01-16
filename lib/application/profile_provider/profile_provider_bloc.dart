import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/common/account_type_id.dart';
import 'package:arachnoit/domain/profile_provider/enterprise_validation.dart';
import 'package:arachnoit/domain/profile_provider/issue_date_validation.dart';
import 'package:arachnoit/domain/profile_provider/title_validation.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/specification_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_specification_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/profile/response/contact_response.dart';
import 'package:arachnoit/infrastructure/profile/response/person_profile_basic_info_response.dart';
import 'package:arachnoit/infrastructure/profile/response/personal_profile_photos.dart';
import 'package:arachnoit/infrastructure/profile/response/profile_info_reponse.dart';
import 'package:arachnoit/infrastructure/profile_provider_lectures/response/qualifications_response.dart';
import 'package:arachnoit/infrastructure/registration/response/cities_by_country_response.dart';
import 'package:arachnoit/infrastructure/registration/response/country_reponse.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/normal_user_personal_info_screen.dart/normal_user_personal_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
part 'profile_provider_event.dart';
part 'profile_provider_state.dart';

class ProfileProviderBloc
    extends Bloc<ProfileProviderEvent, ProfileProviderState> {
  CatalogFacadeService catalogService;
  ProfileProviderBloc({@required this.catalogService})
      : super(ProfileProviderState());

  @override
  Stream<ProfileProviderState> mapEventToState(
      ProfileProviderEvent event) async* {
    if (event is GetProfileInfoEvent) {
      yield* _mapGetProfileInfo(event);
    } else if (event is UpdateContactInfo) {
      yield* _mapUpdateContactInfo(event);
    } else if (event is GetCountry) {
      yield* _mapGetALlCountryEvent(event);
    } else if (event is GetAllCityByCountryEvent) {
      yield* _mapCitiesByCountryToState(event);
    } else if (event is UpdateHealthCareContactInfo) {
      yield* _mapUpdateHealthCareContactInfo(event);
    } else if (event is UpdateNormalUserContactInfoManual) {
      yield* _mapUpdateNormalUserContactInfoManual(event);
    } else if (event is UpdateSocailNetworkEvent) {
      yield* _mapUpdateSocailNetworkEvent(event);
    } else if (event is UpdateHealthCareSocailInfo) {
      yield* _mapUpdateHealthCareSocailInfo(event);
    } else if (event is GetSpecificationsEvent) {
      yield* _mapSpecificationToState(event);
    } else if (event is GetSubSpecificationsEvent) {
      yield* _mapSubSpecificationToState(event);
    } else if (event is ChangeImageScreen) {
      yield* _mapChangeImageScreen(event);
    } else if (event is ChangeUserInfo) {
      yield* _mapChangeUserInfo(event);
    } else if (event is ChangeNormalUserInfo) {
      yield* _mapChangeNormalUserInfo(event);
    }
  }

  Stream<ProfileProviderState> _mapChangeNormalUserInfo(
      ChangeNormalUserInfo event) async* {
    EnterpriseValidation lastName = EnterpriseValidation.dirty(event.lastName);
    IssueDateValidation fireName = IssueDateValidation.dirty(event.firstName);
    FormzStatus fomzState;
   
    fomzState = Formz.validate([lastName]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).last_name,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([fireName]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).first_name,
          event.context);
      yield InvalidState();
      return;
    }

    try {
      final ResponseWrapper<PersonProfileBasicInfoResponse>
          subSpecificationResponse =
          await catalogService.setProfileNormalUserGeneralInfo(
        birthdate: event.birthdate,
        firstName: event.firstName,
        gender: event.gender,
        lastName: event.lastName,
        summary: event.summary,
      );
      switch (subSpecificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessUpdateUserInfo();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapChangeUserInfo(ChangeUserInfo event) async* {
    TitleValidation summary = TitleValidation.dirty(event.summary);
    EnterpriseValidation lastName = EnterpriseValidation.dirty(event.lastName);
    IssueDateValidation fireName = IssueDateValidation.dirty(event.firstName);
    FormzStatus fomzState;
    fomzState = Formz.validate([summary]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).summery,
          event.context);
      yield InvalidState();
      return;
    }
    fomzState = Formz.validate([fireName]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).first_name,
          event.context);
      yield InvalidState();
      return;
    }

    fomzState = Formz.validate([lastName]);
    if (fomzState.isInvalid) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).please_add +
              " " +
              AppLocalizations.of(event.context).last_name,
          event.context);
      yield InvalidState();
      return;
    }
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    try {
      final ResponseWrapper<List<dynamic>> subSpecificationResponse =
          await catalogService.setProfileProviderGeneralInfo(
        birthdate: event.birthdate,
        firstName: event.firstName,
        gender: event.gender,
        inTouchPointName: event.inTouchPointName,
        lastName: event.lastName,
        organizationTypeId: event.organizationTypeId,
        subSpecificationId: event.subSpecificationId,
        summary: event.summary,
      );
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (subSpecificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessUpdateUserInfo();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapChangeImageScreen(
      ChangeImageScreen event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      File file=File("");
      if (!event.isDeleteImage)
        file = await GlobalPurposeFunctions.compressImage(event.image);
      else
        file = File("");
      final ResponseWrapper<PersonalProfilePhotos> subSpecificationResponse =
          await catalogService.setOrDeleteImage(
              isDeleteImage: event.isDeleteImage, image: file);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (subSpecificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          File file = File("");
          if (!event.isDeleteImage) {
            file = File(subSpecificationResponse.data.fileDto.url);
          }
          yield SuccessChangeImage(
            image: file,
          );
          SharedPreferences sharedPreferences =
              serviceLocator<SharedPreferences>();
          String loginResponse =
              sharedPreferences.getString(PrefsKeys.LOGIN_RESPONSE);
          Map<String, dynamic> value = json.decode(loginResponse);
          value["photoUrl"] = file.path;
          sharedPreferences.setString(
              PrefsKeys.LOGIN_RESPONSE, json.encode(value));
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapSubSpecificationToState(
      GetSubSpecificationsEvent event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<List<SubSpecificationResponse>>
          subSpecificationResponse =
          await catalogService.getProfileSubSpecification(
        specificationId: event.specificationId,
      );
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);

      switch (subSpecificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessGetAllSubSpecification(
            items: subSpecificationResponse.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapSpecificationToState(
      GetSpecificationsEvent event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<List<SpecificationResponse>> specificationResponse =
          await catalogService.getProfileSpecification(
              accountTypeId:
                  AccountTypeId().getAccountTypeId(event.accountTypeId));
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (specificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessGetALLSpecification(
            items: specificationResponse.data,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: specificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: specificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapUpdateHealthCareSocailInfo(
      UpdateHealthCareSocailInfo event) async* {
    HealthCareProviderProfileDto profileInfo =
        event.profileInfo.healthcareProviderProfileDto;
    profileInfo.facebook = event.facebook;
    profileInfo.instagram = event.instagram;
    profileInfo.linkedIn = event.linkedIn;
    profileInfo.telegram = event.telegram;
    profileInfo.twiter = event.twiter;
    profileInfo.whatsApp = event.whatsApp;
    profileInfo.youtube = event.youtube;
    event.profileInfo.healthcareProviderProfileDto = profileInfo;
    yield SuccessGetProviderProfile(profileInfoResponse: event.profileInfo);
  }

  Stream<ProfileProviderState> _mapUpdateNormalUserContactInfoManual(
      UpdateNormalUserContactInfoManual event) async* {
    ContactResponse newContactValue = event.newContactValue;
    NormalUserProfileDto profileInfo = event.profileInfo.normalUserProfileDto;
    profileInfo.address = newContactValue?.address ?? "";
    profileInfo.cityId = newContactValue?.cityId ?? "";
    profileInfo.mobile = newContactValue?.mobile ?? "";
    profileInfo.homePhone = newContactValue?.phone ?? "";
    profileInfo.workPhone = newContactValue?.workPhone ?? "";
    profileInfo.city = event.city;
    profileInfo.country = event.country;
    event.profileInfo.normalUserProfileDto = profileInfo;
    yield SuccessGetProviderProfile(profileInfoResponse: event.profileInfo);
  }

  Stream<ProfileProviderState> _mapUpdateHealthCareContactInfo(
      UpdateHealthCareContactInfo event) async* {
    ContactResponse newContactValue = event.newContactValue;
    HealthCareProviderProfileDto profileInfo =
        event.profileInfo.healthcareProviderProfileDto;
    profileInfo.address = newContactValue?.address ?? "";
    profileInfo.cityId = newContactValue?.cityId ?? "";
    profileInfo.mobile = newContactValue?.mobile ?? "";
    profileInfo.homePhone = newContactValue?.phone ?? "";
    profileInfo.workPhone = newContactValue?.workPhone ?? "";
    profileInfo.city = event.city;
    profileInfo.country = event.country;
    event.profileInfo.healthcareProviderProfileDto = profileInfo;
    yield SuccessGetProviderProfile(profileInfoResponse: event.profileInfo);
  }

  Stream<ProfileProviderState> _mapUpdateSocailNetworkEvent(
      UpdateSocailNetworkEvent event) async* {
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    try {
      final ResponseWrapper<bool> citiesByCountry =
          await catalogService.setSocailMedialLink(
        facebook: event.facebook,
        instagram: event.instagram,
        linkedIn: event.linkedIn,
        telegram: event.telegram,
        twiter: event.twiter,
        whatsApp: event.whatsApp,
        youtube: event.youtube,
      );
      if (citiesByCountry.responseType == ResType.ResponseType.SUCCESS) {
        GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
        yield SuccessUpdateSocial();
        return;
      } else {
        GlobalPurposeFunctions.showToast(
            AppLocalizations.of(event.context).check_your_internet_connection,
            event.context);
        GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
        yield RemoteUserClientErrorState();
        return;
      }
    } catch (e) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(event.context).check_your_internet_connection,
          event.context);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapCitiesByCountryToState(
      GetAllCityByCountryEvent event) async* {
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    try {
      final ResponseWrapper<List<CitiesByCountryResponse>> citiesByCountry =
          await catalogService.getSearchProviderCitiesByCountry(
              countryId: event.countryId);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (citiesByCountry.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAllCitiesByCountrySuccessState(
              citiesList: citiesByCountry.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: citiesByCountry.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: citiesByCountry.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapGetALlCountryEvent(GetCountry event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<List<CountryResponse>> countriesResponse =
          await catalogService.getProfileCountry();
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (countriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetAllCountriesState(
            countriesList: countriesResponse.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: countriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: countriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapUpdateContactInfo(
      UpdateContactInfo event) async* {
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    try {
      ResponseWrapper<ContactResponse> profileInfoResponse =
          await catalogService.updateContactInfo(
              address: event.address,
              cityId: event.cityId,
              mobile: event.mobile,
              personId: event.personId,
              phone: event.phone,
              workPhone: event.workPhone);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (profileInfoResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessUpdateContactInfo(
              contactResponse: profileInfoResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: profileInfoResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: profileInfoResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteUserClientErrorState();
      return;
    }
  }

  Stream<ProfileProviderState> _mapGetProfileInfo(
      GetProfileInfoEvent event) async* {
    try {
      yield LoadingProviderInfo();
      ResponseWrapper<ProfileInfoResponse> profileInfoResponse =
          await catalogService.getProfileInfo(userId: event.userId);
      switch (profileInfoResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessGetProviderProfile(
              profileInfoResponse: profileInfoResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteUserValidationErrorState(
            remoteValidationErrorMessage: profileInfoResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteUserProviderServerErrorState(
            remoteServerErrorMessage: profileInfoResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteUserClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteUserClientErrorState();
      return;
    }
  }
}
