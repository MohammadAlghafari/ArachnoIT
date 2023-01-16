part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailOrMobileChanged extends LoginEvent {
  const LoginEmailOrMobileChanged(this.emailOrMobile);

  final String emailOrMobile;

  @override
  List<Object> get props => [emailOrMobile];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginForgetPasswordEmailChanged extends LoginEvent {
  const LoginForgetPasswordEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class ValidateInputsEvent extends LoginEvent {
  const ValidateInputsEvent({this.emailOrMobile,this.password});

  final String emailOrMobile;
  final String password;

  @override
  List<Object> get props => [emailOrMobile,password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({this.emailOrMobile,this.password});

  final String emailOrMobile;
  final String password;

   @override
  List<Object> get props => [emailOrMobile,password];
}

class LoginForgetPasswordSubmitted extends LoginEvent {
  const LoginForgetPasswordSubmitted(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordVisibilityChangedEvent extends LoginEvent {
  const  PasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

