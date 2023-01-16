part of 'registration_socail_bloc.dart';

abstract class RegistrationSocailState {
  const RegistrationSocailState();
}

class RegistrationSocailInitial extends RegistrationSocailState {}

class SuccessValidateFaceBookToken extends RegistrationSocailState {
  SocialResponse socialResponse;
  SocailRegisterParam socailRegisterParam;
  SuccessValidateFaceBookToken(
      {@required this.socialResponse, @required this.socailRegisterParam});
}

class SuccessValidateGoogleToken extends RegistrationSocailState {
  SocialResponse socialResponse;
  SocailRegisterParam socailRegisterParam;
  SuccessValidateGoogleToken(
      {@required this.socialResponse, @required this.socailRegisterParam});
}

class FailedValidateFaceBookToken extends RegistrationSocailState {}

class CanceledFaceBook extends RegistrationSocailState {}

class ErrorHappened extends RegistrationSocailState {}

class SuccessLogin extends RegistrationSocailState {
  String successMessage;
  SuccessLogin({this.successMessage});
}
