part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.emailOrMobile = const EmailOrMobile.pure(),
    this.password = const Password.pure(),
    this.email = const ForgetPasswordEmail.pure(),
  });

  final FormzStatus status;
  final EmailOrMobile emailOrMobile;
  final Password password;
  final ForgetPasswordEmail email;

  LoginState copyWith({
    FormzStatus status,
    EmailOrMobile emailOrMobile,
    Password password,
    ForgetPasswordEmail email,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailOrMobile: emailOrMobile ?? this.emailOrMobile,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [status, emailOrMobile, password,email];
}

class LoginSuccefulState extends LoginState {
  LoginSuccefulState({this.successMessage});

  final String successMessage;
  @override
  List<Object> get props => <dynamic>[successMessage];
}

class LoginRequestResetPasswordSuccefulState extends LoginState {
  LoginRequestResetPasswordSuccefulState({this.successMessage});

  final String successMessage;
  @override
  List<Object> get props => <dynamic>[successMessage];
}

class RemoteValidationErrorState extends LoginState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  @override
  List<Object> get props => [remoteValidationErrorMessage];
}

class RemoteServerErrorState extends LoginState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorState extends LoginState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  @override
  List<Object> get props => [remoteClientErrorMessage];
}

class AccountNeedsActivationState extends LoginState {
  AccountNeedsActivationState();

  @override
  List<Object> get props => [];
}
class LoginRequestResetPasswordLoadingState extends LoginState {
  LoginRequestResetPasswordLoadingState();

  @override
  List<Object> get props => [];
}

class InputsValidatedState extends LoginState {
  const InputsValidatedState();

  @override
  List<Object> get props => [];
}

class PasswordVisibilityChangedState extends LoginState {
  const PasswordVisibilityChangedState({this.visibility});

  final bool visibility;

   @override
  List<Object> get props => [visibility];
}
