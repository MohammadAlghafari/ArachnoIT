part of 'forget_password_bloc.dart';

 class ForgetPasswordState extends Equatable {
  const ForgetPasswordState(
    {
       this.status = FormzStatus.pure,
    this.newPassword = const ForgetPasswordPassword.pure(),
    this.confirmPassword = const ForgetPasswordConfirmPassword.pure(["",""]),
    }
  );
  final FormzStatus status;
  final ForgetPasswordPassword newPassword;
  final ForgetPasswordConfirmPassword confirmPassword;

  ForgetPasswordState copyWith({
    FormzStatus status,
    ForgetPasswordPassword newPassword,
    ForgetPasswordConfirmPassword confirmPassword,
  }) {
    return ForgetPasswordState(
      status: status ?? this.status,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
  
  @override
  List<Object> get props => [status, newPassword, confirmPassword];
}

class NewPasswordVisibilityChangedState extends ForgetPasswordState {
  const NewPasswordVisibilityChangedState({this.visibility});

  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class ConfirmPasswordVisibilityChangedState extends ForgetPasswordState {
  const ConfirmPasswordVisibilityChangedState({this.visibility});

  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class InputsValidatedState extends ForgetPasswordState {
  const InputsValidatedState();

  @override
  List<Object> get props => [];
}


class ResetPasswordSuccefulState extends ForgetPasswordState {
  ResetPasswordSuccefulState({this.successMessage});

  final String successMessage;
  @override
  List<Object> get props => <dynamic>[successMessage];
}

class RemoteValidationErrorState extends ForgetPasswordState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  @override
  List<Object> get props => [remoteValidationErrorMessage];
}

class RemoteServerErrorState extends ForgetPasswordState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorState extends ForgetPasswordState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  @override
  List<Object> get props => [remoteClientErrorMessage];
}
