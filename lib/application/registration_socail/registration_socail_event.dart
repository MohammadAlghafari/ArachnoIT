part of 'registration_socail_bloc.dart';

abstract class RegistrationSocailEvent  {
  const RegistrationSocailEvent();

}

class ValidateFaceBookTokenEvent extends RegistrationSocailEvent {
  final BuildContext context;
  ValidateFaceBookTokenEvent({@required this.context});
}

class LoginUsingFaceBook extends RegistrationSocailEvent {
  final String accessToken;
  final String email;
  final BuildContext context;
  LoginUsingFaceBook(
      {@required this.accessToken,
      @required this.email,
      @required this.context});
}

class ValidateGoogleTokenEvent extends RegistrationSocailEvent {
  final BuildContext context;
  ValidateGoogleTokenEvent({@required this.context});
}

class LoginUsingGoogle extends RegistrationSocailEvent {
  final String accessToken;
  final String email;
  final BuildContext context;
  LoginUsingGoogle(
      {@required this.accessToken,
      @required this.email,
      @required this.context});
}
