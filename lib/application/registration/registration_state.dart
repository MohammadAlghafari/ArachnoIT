part of 'registration_bloc.dart';

@immutable
class RegistrationState /* extends Equatable */ {
  const RegistrationState({
    this.status = FormzStatus.pure,
    this.firstName = const RegistrationFirstName.pure(),
    this.lastName = const RegistrationLastName.pure(),
    this.touchPointName = const RegistrationTouchPointName.pure(),
    this.email = const RegistrationEmail.pure(),
    this.mobile = const RegistrationMobile.pure(),
    this.password = const RegistrationPassword.pure(),
    this.confirmPassword = const RegistrationConfirmPassword.pure(["",""]),
    this.dateOfBirth = const RegistrationDateOfBirth.pure(),
    this.qualification = const RegistrationQualification.pure(),
    this.speciality = const RegistrationSpeciality.pure(),
    this.country = const RegistrationCountry.pure(),
    this.city = const RegistrationCity.pure(),
  });

  final FormzStatus status;
  final RegistrationFirstName firstName;
  final RegistrationLastName lastName;
  final RegistrationTouchPointName touchPointName;
  final RegistrationEmail email;
  final RegistrationMobile mobile;
  final RegistrationPassword password;
  final RegistrationConfirmPassword confirmPassword;
  final RegistrationDateOfBirth dateOfBirth;
  final RegistrationQualification qualification;
  final RegistrationSpeciality speciality;
  final RegistrationCountry country;
  final RegistrationCity city;

  RegistrationState copyWith({
    FormzStatus status,
    RegistrationFirstName firstName,
    RegistrationLastName lastName,
    RegistrationTouchPointName touchPointName,
    RegistrationEmail email,
    RegistrationMobile mobile,
    RegistrationPassword password,
    RegistrationConfirmPassword confirmPassword,
    RegistrationDateOfBirth dateOfBirth,
    RegistrationQualification qualification,
    RegistrationSpeciality speciality,
    RegistrationCountry country,
    RegistrationCity city,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      touchPointName: touchPointName ?? this.touchPointName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      qualification: qualification ?? this.qualification,
      speciality: speciality ?? this.speciality,
      country: country ?? this.country,
      city: city ?? this.city,
    );
  }

  /* @override
  List<Object> get props => [
        status,
        firstName,
        lastName,
        touchPointName,
        email,
        mobile,
        password,
        confirmPassword,
        dateOfBirth,
        qualification,
        speciality,
        country,
        city,
      ]; */
}

class RegistrationSuccefulState extends RegistrationState {
  RegistrationSuccefulState({this.registrationResponse});

  final dynamic registrationResponse;
  /* @override
  List<Object> get props => <dynamic>[registrationResponse]; */
}

class RemoteValidationErrorState extends RegistrationState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  /* @override
  List<Object> get props => [remoteValidationErrorMessage]; */
}

class RemoteServerErrorState extends RegistrationState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  /* @override
  List<Object> get props => [remoteServerErrorMessage]; */
}

class RemoteClientErrorState extends RegistrationState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  /* @override
  List<Object> get props => [remoteClientErrorMessage]; */
}

class AccountTypeChangedState extends RegistrationState {
  AccountTypeChangedState({this.accountType});

  final String accountType;
 /*  @override
  List<Object> get props => [accountType]; */
}

class AccountTypesState extends RegistrationState {
  AccountTypesState();

 /*  @override
  List<Object> get props => []; */
}

class SpecificationState extends RegistrationState {
  SpecificationState({this.specification});
  final List<SpecificationResponse> specification;
 /*  @override
  List<Object> get props => [specification]; */
}

class SubSpecificationState extends RegistrationState {
  SubSpecificationState({this.subSpecifications});
  final List<SubSpecificationResponse> subSpecifications;
  /* @override
  List<Object> get props => [subSpecifications]; */
}

class CountriesState extends RegistrationState {
  CountriesState({this.countries});
  final List<CountryResponse> countries;
  /* @override
  List<Object> get props => [countries]; */
}

class CititesByCountryState extends RegistrationState {
  CititesByCountryState({this.cities});
  final List<CitiesByCountryResponse> cities;
 /*  @override
  List<Object> get props => [cities]; */
}

class IndividualAccountIdState extends RegistrationState {
  IndividualAccountIdState({this.accountTypeId});

  final String accountTypeId;
 /*  @override
  List<Object> get props => [accountTypeId]; */
}

class EnterpriseAccountIdState extends RegistrationState {
  EnterpriseAccountIdState({this.accountTypeId});

  final String accountTypeId;
  /* @override
  List<Object> get props => [accountTypeId]; */
}

class LoadingState extends RegistrationState {
  LoadingState();

  /* @override
  List<Object> get props => []; */
}

class LoadingAvailabilityState extends RegistrationState {
  LoadingAvailabilityState();

  /* @override
  List<Object> get props => []; */
}

class RegistrationGenderChangedState extends RegistrationState {
  const RegistrationGenderChangedState(this.genderType);
  final int genderType;
  /* @override
  List<Object> get props => [genderType]; */
}

class RegistrationAgreeOnTermsChangedState extends RegistrationState {
  const RegistrationAgreeOnTermsChangedState(this.agree);
  final bool agree;
 /*  @override
  List<Object> get props => [agree]; */
}

class RegistrationIsTouchPointNameEmailMobileAvailableState
    extends RegistrationState {
  const RegistrationIsTouchPointNameEmailMobileAvailableState(
    this.touchPointNameAvailable,
    this.emailAvailable,
    this.mobileAvailable,
  );
  final TouchPointNameAvailableResponse touchPointNameAvailable;
  final EmailAvailableResponse emailAvailable;
  final PhoneNumberAvailableResponse mobileAvailable;
 /*  @override
  List<Object> get props => [
        touchPointNameAvailable,
        emailAvailable,
        mobileAvailable,
      ]; */
}

class RegistrationIsEmailMobileAvailableState
    extends RegistrationState {
  const RegistrationIsEmailMobileAvailableState(
    this.emailAvailable,
    this.mobileAvailable,
  );
  
  final EmailAvailableResponse emailAvailable;
  final PhoneNumberAvailableResponse mobileAvailable;
  /* @override
  List<Object> get props => [
        emailAvailable,
        mobileAvailable,
      ]; */
}

class RegistrationUserRegisteredState extends RegistrationState {
  RegistrationUserRegisteredState();

 /*  @override
  List<Object> get props => []; */
}

class RegistrationInputValidatedState extends RegistrationState {
  RegistrationInputValidatedState();

 /*  @override
  List<Object> get props => []; */
}

class PasswordVisibilityChangedState extends RegistrationState {
  const PasswordVisibilityChangedState({this.visibility});

  final bool visibility;

 
}

class ConfirmPasswordVisibilityChangedState extends RegistrationState {
  const ConfirmPasswordVisibilityChangedState({this.visibility});

  final bool visibility;

  
}




