import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/infrastructure/registration/response/touch_point_name_available.dart';
import 'package:bloc/bloc.dart';
//import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/app_const.dart';
import '../../common/pref_keys.dart';
import '../../domain/registration/local/registration_city.dart';
import '../../domain/registration/local/registration_confirm_password.dart';
import '../../domain/registration/local/registration_country.dart';
import '../../domain/registration/local/registration_date_of_birth.dart';
import '../../domain/registration/local/registration_email.dart';
import '../../domain/registration/local/registration_first_name.dart';
import '../../domain/registration/local/registration_last_name.dart';
import '../../domain/registration/local/registration_mobile.dart';
import '../../domain/registration/local/registration_password.dart';
import '../../domain/registration/local/registration_qualification.dart';
import '../../domain/registration/local/registration_speciality.dart';
import '../../domain/registration/local/registration_touch_point_name.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/registration/response/account_types_response.dart';
import '../../infrastructure/registration/response/cities_by_country_response.dart';
import '../../infrastructure/registration/response/country_reponse.dart';
import '../../infrastructure/registration/response/email_available_response.dart';
import '../../infrastructure/registration/response/phone_number_available.dart';
import '../../infrastructure/common_response/specification_response.dart';
import '../../infrastructure/common_response/sub_specification_response.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const RegistrationState());

  final CatalogFacadeService catalogService;

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is GetAccountTypesEvent)
      yield* _mapAccountTypesToState();
    else if (event is IndividualSelectedEvent)
      yield AccountTypeChangedState(accountType: AppConst.INDIVIDUAL);
    else if (event is EnterpriseSelectedEvent)
      yield AccountTypeChangedState(accountType: AppConst.BUSINESS);
    else if (event is NextButtonPressedEvent)
      yield* _mapNextPressedToState(event.accountType);
    else if (event is RegistrationFirstNameChanged)
      yield _mapValidateFirstNameChangedToState(event, state);
    else if (event is RegistrationLastNameChanged)
      yield _mapValidateLastNameChangedToState(event, state);
    else if (event is RegistrationTouchPointNameChanged)
      yield _mapValidateTouchPointNameChangedToState(event, state);
    else if (event is RegistrationDateOfBirthChanged)
      yield _mapValidateDateOfBirthChangedToState(event, state);
    else if (event is RegistrationQualificationChanged)
      yield _mapValidateQualificationChangedToState(event, state);
    else if (event is RegistrationSpecialityChanged)
      yield _mapValidateSpecialityChangedToState(event, state);
    else if (event is RegistrationEmailChanged)
      yield _mapValidateEmailChangedToState(event, state);
    else if (event is RegistrationCountryChanged)
      yield _mapValidateCountryChangedToState(event, state);
    else if (event is RegistrationCityChanged)
      yield _mapValidateCityChangedToState(event, state);
    else if (event is RegistrationMobileChanged)
      yield _mapValidateMobileChangedToState(event, state);
    else if (event is RegistrationPasswordChanged)
      yield _mapValidatePasswordChangedToState(event, state);
    else if (event is RegistrationConfirmPasswordChanged)
      yield _mapValidateConfirmPasswordChangedToState(event, state);
    else if (event is RegistrationGenderChangedEvent)
      yield RegistrationGenderChangedState(event.genderType);
    else if (event is RegistrationAgreeOnTermsChangedEvent)
      yield RegistrationAgreeOnTermsChangedState(event.agreeOnTerms);
    else if (event is GetSpecificationsEvent)
      yield* _mapSpecificationToState(event);
    else if (event is GetSubSpecificationsEvent)
      yield* _mapSubSpecificationToState(event);
    else if (event is GetCountriesEvent)
      yield* _mapCountriesToState(state);
    else if (event is GetCitiesByCountryEvent)
      yield* _mapCitiesByCountryToState(event,);
    else if (event is RegistrationValidateNormalUserInputs)
      yield _mapValidateNormalUserInputsToState(event, state);
    else if (event is RegistrationValidateIndividualOrBusinessUserInputs)
      yield _mapValidateIndividualOrBusinessUserInputsToState(event, state);
    else if (event is RegistrationValidateNameEmailPhone)
      yield* _mapValidateNameEmailMobileToState(event);
    else if (event is RegistrationValidateEmailPhone)
      yield* _mapValidateEmailMobileToState(event);
    else if (event is RegistrationRegisterHealthCareProvider)
      yield* _mapRegisterHealthCareProviderToState(event);
    else if (event is RegistrationRegisterNormalUser)
      yield* _mapRegisterNormalUserToState(event);
     else if (event is PasswordVisibilityChangedEvent)
      yield PasswordVisibilityChangedState(visibility: !event.visibility);
    else if (event is ConfirmPasswordVisibilityChangedEvent)
      yield ConfirmPasswordVisibilityChangedState(
          visibility: !event.visibility);
  }

  RegistrationState _mapValidateFirstNameChangedToState(
    RegistrationFirstNameChanged event,
    RegistrationState state,
  ) {
    final firstName = RegistrationFirstName.dirty(event.firstName);
    return state = state.copyWith(
        firstName: firstName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          firstName
        ]));
  }

  RegistrationState _mapValidateLastNameChangedToState(
    RegistrationLastNameChanged event,
    RegistrationState state,
  ) {
    final lastName = RegistrationLastName.dirty(event.lastName);
    return state = state.copyWith(
        lastName: lastName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateTouchPointNameChangedToState(
    RegistrationTouchPointNameChanged event,
    RegistrationState state,
  ) {
    final touchPointName =
        RegistrationTouchPointName.dirty(event.touchPointName);
    return state = state.copyWith(
        touchPointName: touchPointName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateDateOfBirthChangedToState(
    RegistrationDateOfBirthChanged event,
    RegistrationState state,
  ) {
    final dateOfBirth = RegistrationDateOfBirth.dirty(event.dateOfBirth);
    return state = state.copyWith(
        dateOfBirth: dateOfBirth,
        status: Formz.validate([
          state.country,
          state.email,
          dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateQualificationChangedToState(
    RegistrationQualificationChanged event,
    RegistrationState state,
  ) {
    final qualification = RegistrationQualification.dirty(event.qualification);
    return state = state.copyWith(
        qualification: qualification,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateSpecialityChangedToState(
    RegistrationSpecialityChanged event,
    RegistrationState state,
  ) {
    final speciality = RegistrationSpeciality.dirty(event.speciality);
    return state = state.copyWith(
        speciality: speciality,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateEmailChangedToState(
    RegistrationEmailChanged event,
    RegistrationState state,
  ) {
    final email = RegistrationEmail.dirty(event.email);
    return state = state.copyWith(
        email: email,
        status: Formz.validate([
          state.country,
          email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateCountryChangedToState(
    RegistrationCountryChanged event,
    RegistrationState state,
  ) {
    final country = RegistrationCountry.dirty(event.country);
    return state = state.copyWith(
        country: country,
        status: Formz.validate([
          country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateCityChangedToState(
    RegistrationCityChanged event,
    RegistrationState state,
  ) {
    final city = RegistrationCity.dirty(event.city);
    return state = state.copyWith(
        city: city,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateMobileChangedToState(
    RegistrationMobileChanged event,
    RegistrationState state,
  ) {
    final mobile = RegistrationMobile.dirty(event.mobile);
    return state = state.copyWith(
        mobile: mobile,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidatePasswordChangedToState(
    RegistrationPasswordChanged event,
    RegistrationState state,
  ) {
    final password = RegistrationPassword.dirty(event.password);
    return state = state.copyWith(
        password: password,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateConfirmPasswordChangedToState(
    RegistrationConfirmPasswordChanged event,
    RegistrationState state,
  ) {
    final confirmPassword =
        RegistrationConfirmPassword.dirty([event.confirmPassword,state.password.value]);
    return state = state.copyWith(
        confirmPassword: confirmPassword,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
  }

  RegistrationState _mapValidateNormalUserInputsToState(
    RegistrationValidateNormalUserInputs event,
    RegistrationState state,
  ) {
    final firstName = RegistrationFirstName.dirty(event.firstName);
    final lastName = RegistrationLastName.dirty(event.lastName);
    final dateOfBirth = RegistrationDateOfBirth.dirty(event.dateOfBirth);
    final email = RegistrationEmail.dirty(event.email);
    final country = RegistrationCountry.dirty(event.country);
    final city = RegistrationCity.dirty(event.city);
    final mobile = RegistrationMobile.dirty(event.mobile);
    final password = RegistrationPassword.dirty(event.password);
    final confirmPassword =
        RegistrationConfirmPassword.dirty([event.confirmPassword,event.password]);
    state = state.copyWith(
        firstName: firstName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.mobile,
          state.lastName,
          state.password,
          firstName
        ]));
    if (state.firstName.invalid) return state;
    state = state.copyWith(
        lastName: lastName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.mobile,
          lastName,
          state.password,
          state.firstName
        ]));
    if (state.lastName.invalid) return state;
    state = state.copyWith(
        dateOfBirth: dateOfBirth,
        status: Formz.validate([
          state.country,
          state.email,
          dateOfBirth,
          state.confirmPassword,
          state.city,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.dateOfBirth.invalid) return state;
    state = state.copyWith(
        email: email,
        status: Formz.validate([
          state.country,
          email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.email.invalid) return state;
    state = state.copyWith(
        country: country,
        status: Formz.validate([
          country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.country.invalid) return state;
    state = state.copyWith(
        city: city,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          city,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.city.invalid) return state;
    state = state.copyWith(
        mobile: mobile,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.mobile.invalid) return state;
    state = state.copyWith(
        password: password,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.mobile,
          state.lastName,
          password,
          state.firstName
        ]));
    if (state.password.invalid) return state;
    state = state.copyWith(
        confirmPassword: confirmPassword,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          confirmPassword,
          state.city,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.confirmPassword.invalid)
      return state;
    else
      return RegistrationInputValidatedState();
  }

  RegistrationState _mapValidateIndividualOrBusinessUserInputsToState(
    RegistrationValidateIndividualOrBusinessUserInputs event,
    RegistrationState state,
  ) {
    final firstName = RegistrationFirstName.dirty(event.firstName);
    final lastName = RegistrationLastName.dirty(event.lastName);
    final touchPointName =
        RegistrationTouchPointName.dirty(event.touchPointName);
    final dateOfBirth = RegistrationDateOfBirth.dirty(event.dateOfBirth);
    final qualification = RegistrationQualification.dirty(event.qualification);
    final speciality = RegistrationSpeciality.dirty(event.speciality);
    final email = RegistrationEmail.dirty(event.email);
    final country = RegistrationCountry.dirty(event.country);
    final city = RegistrationCity.dirty(event.city);
    final mobile = RegistrationMobile.dirty(event.mobile);
    final password = RegistrationPassword.dirty(event.password);
    final confirmPassword =
        RegistrationConfirmPassword.dirty([event.confirmPassword,event.password]);
    state = state.copyWith(
        firstName: firstName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          firstName
        ]));
    if (state.firstName.invalid) return state;
    state = state.copyWith(
        lastName: lastName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          lastName,
          state.password,
          state.firstName
        ]));
    if (state.lastName.invalid) return state;
    state = state.copyWith(
        touchPointName: touchPointName,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.touchPointName.invalid) return state;
    state = state.copyWith(
        dateOfBirth: dateOfBirth,
        status: Formz.validate([
          state.country,
          state.email,
          dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.dateOfBirth.invalid) return state;
    state = state.copyWith(
        qualification: qualification,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.qualification.invalid) return state;
    state = state.copyWith(
        speciality: speciality,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.speciality.invalid) return state;
    state = state.copyWith(
        email: email,
        status: Formz.validate([
          state.country,
          email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.email.invalid) return state;
    state = state.copyWith(
        country: country,
        status: Formz.validate([
          country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.country.invalid) return state;
    state = state.copyWith(
        city: city,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.city.invalid) return state;
    state = state.copyWith(
        mobile: mobile,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.mobile.invalid) return state;
    state = state.copyWith(
        password: password,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          state.confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          password,
          state.firstName
        ]));
    if (state.password.invalid) return state;
    state = state.copyWith(
        confirmPassword: confirmPassword,
        status: Formz.validate([
          state.country,
          state.email,
          state.dateOfBirth,
          confirmPassword,
          state.city,
          state.touchPointName,
          state.speciality,
          state.qualification,
          state.mobile,
          state.lastName,
          state.password,
          state.firstName
        ]));
    if (state.confirmPassword.invalid)
      return state;
    else
      return RegistrationInputValidatedState();
  }

  Stream<RegistrationState> _mapAccountTypesToState() async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<AccountTypesResponse>> accountTypesResponse =
          await catalogService.getAccountTypes();
      switch (accountTypesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(
              PrefsKeys.ACCOUNT_TYPES_RESPONSE,
              jsonEncode(
                  accountTypesResponse.data.map((e) => e.toJson()).toList()));
          yield AccountTypesState();
          yield AccountTypeChangedState(
            accountType: AppConst.UNKNOWN,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: accountTypesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: accountTypesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<RegistrationState> _mapSpecificationToState(
      GetSpecificationsEvent event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<SpecificationResponse>> specificationResponse =
          await catalogService.getSpecification(
              accountTypeId: event.accountTypeId);
      switch (specificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SpecificationState(
            specification: specificationResponse.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: specificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: specificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<RegistrationState> _mapSubSpecificationToState(
      GetSubSpecificationsEvent event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<SubSpecificationResponse>>
          subSpecificationResponse = await catalogService.getSubSpecification(
        specificationId: event.specificationId,
      );
      switch (subSpecificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SubSpecificationState(
            subSpecifications: subSpecificationResponse.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: subSpecificationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<RegistrationState> _mapCountriesToState(RegistrationState state,) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<CountryResponse>> countriesResponse =
          await catalogService.getCountries();
      switch (countriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield CountriesState(
            countries: countriesResponse.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: countriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: countriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<RegistrationState> _mapCitiesByCountryToState(
      GetCitiesByCountryEvent event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<List<CitiesByCountryResponse>> citiesByCountry =
          await catalogService.getCitiesByCountry(countryId: event.countryId);
      switch (citiesByCountry.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield CititesByCountryState(
            cities: citiesByCountry.data,
          );

          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: citiesByCountry.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: citiesByCountry.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<RegistrationState> _mapNextPressedToState(String accountType) async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<dynamic> accountTypesAsDynamicList =
          jsonDecode(prefs.getString(PrefsKeys.ACCOUNT_TYPES_RESPONSE));
      List<AccountTypesResponse> accountTypes = List();
      accountTypesAsDynamicList.forEach((element) {
        accountTypes.add(AccountTypesResponse.fromJson(element as String));
      });
      String accountTypeId;
      switch (accountType) {
        case AppConst.INDIVIDUAL:
          accountTypeId =
              accountTypes.singleWhere((element) => element.template == 0).id;
          yield EnterpriseAccountIdState(
            accountTypeId: accountTypeId,
          );
          break;
        case AppConst.BUSINESS:
          accountTypeId =
              accountTypes.singleWhere((element) => element.template == 1).id;
          yield IndividualAccountIdState(
            accountTypeId: accountTypeId,
          );
          break;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<RegistrationState> _mapValidateNameEmailMobileToState(
      RegistrationValidateNameEmailPhone event) async* {
    try {
      yield LoadingAvailabilityState();
      final ResponseWrapper<List<dynamic>> nameEmailMobialAvailabilityResponse =
          await catalogService.isTouchPointNameEmailMobileAvailable(
        touchPointName: event.touchPointName,
        email: event.email,
        mobile: event.mobile,
      );
      switch (nameEmailMobialAvailabilityResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
        TouchPointNameAvailableResponse nameResponse = nameEmailMobialAvailabilityResponse.data[0];
         EmailAvailableResponse emailResponse =
              nameEmailMobialAvailabilityResponse.data[1];
          PhoneNumberAvailableResponse mobileResponse =
              nameEmailMobialAvailabilityResponse.data[2];
          yield RegistrationIsTouchPointNameEmailMobileAvailableState(
              nameResponse,
              emailResponse,
              mobileResponse);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage:
                nameEmailMobialAvailabilityResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage:
                nameEmailMobialAvailabilityResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<RegistrationState> _mapValidateEmailMobileToState(
      RegistrationValidateEmailPhone event) async* {
    try {
      yield LoadingAvailabilityState();
      final ResponseWrapper<List<dynamic>> emailMobialAvailabilityResponse =
          await catalogService.isEmailMobileAvailable(
        email: event.email,
        mobile: event.mobile,
      );
      switch (emailMobialAvailabilityResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          EmailAvailableResponse emailResponse =
              emailMobialAvailabilityResponse.data[0];
          PhoneNumberAvailableResponse mobileResponse =
              emailMobialAvailabilityResponse.data[1];
          yield RegistrationIsEmailMobileAvailableState(
            emailResponse,
            mobileResponse,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage:
                emailMobialAvailabilityResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage:
                emailMobialAvailabilityResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    }
     catch (e) {
       print(e);
     }
  }

  Stream<RegistrationState> _mapRegisterHealthCareProviderToState(
      RegistrationRegisterHealthCareProvider event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<String> registerResponse =
          await catalogService.registerHealthCareProvider(
        inTouchPointName: event.inTouchPointName,
        subSpecificationId: event.subSpecificationId,
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        birthdate: event.birthdate,
        gender: event.gender,
        password: event.password,
        mobile: event.mobile,
        cityId: event.cityId,
      );
      switch (registerResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefsKeys.EMAIL, event.email);
          prefs.setString(PrefsKeys.PHONE_NUMBER, event.mobile);
          prefs.setBool(PrefsKeys.IS_VERIFIED, false);
          yield RegistrationUserRegisteredState();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: registerResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: registerResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<RegistrationState> _mapRegisterNormalUserToState(
      RegistrationRegisterNormalUser event) async* {
    try {
      yield LoadingState();
      final ResponseWrapper<String> registerResponse =
          await catalogService.registerNormalUser(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        birthdate: event.birthdate,
        gender: event.gender,
        password: event.password,
        mobile: event.mobile,
        cityId: event.cityId,
      );
      switch (registerResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefsKeys.EMAIL, event.email);
          prefs.setString(PrefsKeys.PHONE_NUMBER, event.mobile);
          prefs.setBool(PrefsKeys.IS_VERIFIED, false);
          yield RegistrationUserRegisteredState();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: registerResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: registerResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }
}
