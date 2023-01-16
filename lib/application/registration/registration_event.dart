part of 'registration_bloc.dart';

@immutable
abstract class RegistrationEvent /* extends Equatable */ {
  const RegistrationEvent();

  /* @override
  List<Object> get props => []; */
}

class RegistrationFirstNameChanged extends RegistrationEvent {
  const RegistrationFirstNameChanged(this.firstName);

  final String firstName;

  /* @override
  List<Object> get props => [firstName]; */
}

class RegistrationLastNameChanged extends RegistrationEvent {
  const RegistrationLastNameChanged(this.lastName);

  final String lastName;

 /*  @override
  List<Object> get props => [lastName]; */
}

class RegistrationTouchPointNameChanged extends RegistrationEvent {
  const RegistrationTouchPointNameChanged(this.touchPointName);

  final String touchPointName;

  /* @override
  List<Object> get props => [touchPointName]; */
}

class RegistrationDateOfBirthChanged extends RegistrationEvent {
  const RegistrationDateOfBirthChanged(this.dateOfBirth);

  final String dateOfBirth;

  /* @override
  List<Object> get props => [dateOfBirth]; */
}

class RegistrationQualificationChanged extends RegistrationEvent {
  const RegistrationQualificationChanged(this.qualification);

  final String qualification;

  /* @override
  List<Object> get props => [qualification]; */
}

class RegistrationSpecialityChanged extends RegistrationEvent {
  const RegistrationSpecialityChanged(this.speciality);

  final String speciality;

 /*  @override
  List<Object> get props => [speciality]; */
}

class RegistrationEmailChanged extends RegistrationEvent {
  const RegistrationEmailChanged(this.email);

  final String email;

  /* @override
  List<Object> get props => [email]; */
}

class RegistrationCountryChanged extends RegistrationEvent {
  const RegistrationCountryChanged(this.country);

  final String country;

  /* @override
  List<Object> get props => [country]; */
}

class RegistrationCityChanged extends RegistrationEvent {
  const RegistrationCityChanged(this.city);

  final String city;

 /*  @override
  List<Object> get props => [city]; */
}

class RegistrationMobileChanged extends RegistrationEvent {
  const RegistrationMobileChanged(this.mobile);

  final String mobile;

  /* @override
  List<Object> get props => [mobile]; */
}

class RegistrationPasswordChanged extends RegistrationEvent {
  const RegistrationPasswordChanged(this.password);

  final String password;

  /* @override
  List<Object> get props => [password]; */
}

class RegistrationConfirmPasswordChanged extends RegistrationEvent {
  const RegistrationConfirmPasswordChanged(this.confirmPassword);

  final String confirmPassword;

  /* @override
  List<Object> get props => [confirmPassword]; */
}

class RegistrationSubmitted extends RegistrationEvent {
  const RegistrationSubmitted();
}

class GetAccountTypesEvent extends RegistrationEvent {
  const GetAccountTypesEvent();
}

class GetSpecificationsEvent extends RegistrationEvent {
  const GetSpecificationsEvent(this.accountTypeId);
  final String accountTypeId;
  /* @override
  List<Object> get props => [accountTypeId]; */
}

class GetSubSpecificationsEvent extends RegistrationEvent {
  const GetSubSpecificationsEvent(this.specificationId);
  final String specificationId;
  /* @override
  List<Object> get props => [specificationId]; */
}

class GetCountriesEvent extends RegistrationEvent {
  const GetCountriesEvent();
}

class GetCitiesByCountryEvent extends RegistrationEvent {
  const GetCitiesByCountryEvent(this.countryId);
  final String countryId;
  /* @override
  List<Object> get props => [countryId]; */
}

class IndividualSelectedEvent extends RegistrationEvent {
  const IndividualSelectedEvent();
}

class EnterpriseSelectedEvent extends RegistrationEvent {
  const EnterpriseSelectedEvent();
}

class NextButtonPressedEvent extends RegistrationEvent {
  const NextButtonPressedEvent(this.accountType);
  final String accountType;
  /* @override
  List<Object> get props => [accountType]; */
}

class RegistrationGenderChangedEvent extends RegistrationEvent {
  const RegistrationGenderChangedEvent(this.genderType);
  final int genderType;
 /*  @override
  List<Object> get props => [genderType]; */
}

class RegistrationAgreeOnTermsChangedEvent extends RegistrationEvent {
  const RegistrationAgreeOnTermsChangedEvent(this.agreeOnTerms);
  final bool agreeOnTerms;
 /*  @override
  List<Object> get props => [agreeOnTerms]; */
}

class RegistrationValidateNormalUserInputs extends RegistrationEvent {
  const RegistrationValidateNormalUserInputs({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.email,
    this.country,
    this.city,
    this.mobile,
    this.password,
    this.confirmPassword,
  });

  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String email;
  final String country;
  final String city;
  final String mobile;
  final String password;
  final String confirmPassword;

 /*  @override
  List<Object> get props => [
        firstName,
        lastName,
        dateOfBirth,
        email,
        country,
        city,
        mobile,
        password,
        confirmPassword,
      ]; */
}

class RegistrationValidateIndividualOrBusinessUserInputs
    extends RegistrationEvent {
  const RegistrationValidateIndividualOrBusinessUserInputs({
    this.firstName,
    this.lastName,
    this.touchPointName,
    this.dateOfBirth,
    this.qualification,
    this.speciality,
    this.email,
    this.country,
    this.city,
    this.mobile,
    this.password,
    this.confirmPassword,
  });

  final String firstName;
  final String lastName;
  final String touchPointName;
  final String dateOfBirth;
  final String qualification;
  final String speciality;
  final String email;
  final String country;
  final String city;
  final String mobile;
  final String password;
  final String confirmPassword;

  /* @override
  List<Object> get props => [
        firstName,
        lastName,
        touchPointName,
        dateOfBirth,
        qualification,
        speciality,
        email,
        country,
        city,
        mobile,
        password,
        confirmPassword,
      ]; */
}

class RegistrationValidateNameEmailPhone extends RegistrationEvent {
  const RegistrationValidateNameEmailPhone({
    this.touchPointName,
    this.email,
    this.mobile,
  });
  final String touchPointName;
  final String email;
  final String mobile;
  /* @override
  List<Object> get props => [
        touchPointName,
        email,
        mobile,
      ]; */
}

class RegistrationValidateEmailPhone extends RegistrationEvent {
  const RegistrationValidateEmailPhone({
    this.email,
    this.mobile,
  });
  final String email;
  final String mobile;
  /* @override
  List<Object> get props => [
        email,
        mobile,
      ]; */
}

class RegistrationRegisterHealthCareProvider extends RegistrationEvent {
  const RegistrationRegisterHealthCareProvider({
    @required this.inTouchPointName,
    @required this.subSpecificationId,
    @required this.email,
    @required this.firstName,
    @required this.lastName,
    @required this.birthdate,
    @required this.gender,
    @required this.password,
    @required this.mobile,
    @required this.cityId,
  });
  final String inTouchPointName;
  final String subSpecificationId;
  final String email;
  final String firstName;
  final String lastName;
  final String birthdate;
  final int gender;
  final String password;
  final String mobile;
  final String cityId;
 /*  @override
  List<Object> get props => [
        inTouchPointName,
        subSpecificationId,
        email,
        firstName,
        lastName,
        birthdate,
        gender,
        password,
        mobile,
        cityId,
      ]; */
}

class RegistrationRegisterNormalUser extends RegistrationEvent {
  const RegistrationRegisterNormalUser({
    @required this.email,
    @required this.firstName,
    @required this.lastName,
    @required this.birthdate,
    @required this.gender,
    @required this.password,
    @required this.mobile,
    @required this.cityId,
  });
  final String email;
  final String firstName;
  final String lastName;
  final String birthdate;
  final int gender;
  final String password;
  final String mobile;
  final String cityId;
 /*  @override
  List<Object> get props => [
        email,
        firstName,
        lastName,
        birthdate,
        gender,
        password,
        mobile,
        cityId,
      ]; */
}

class PasswordVisibilityChangedEvent extends RegistrationEvent {
  const  PasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;


}

class ConfirmPasswordVisibilityChangedEvent extends RegistrationEvent {
  const ConfirmPasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;

}
