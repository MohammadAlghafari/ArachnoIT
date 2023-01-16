part of 'change_password_bloc.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = FormzStatus.pure,
    this.currentPassword = const ChangePasswordCurrentPassword.pure(),
    this.newPassword = const ChangePasswordNewPassword.pure(["", ""]),
    this.confirmPassword = const ChangePasswordConfirmPassword.pure(["", ""]),
  });

  final FormzStatus status;
  final ChangePasswordCurrentPassword currentPassword;
  final ChangePasswordNewPassword newPassword;
  final ChangePasswordConfirmPassword confirmPassword;

  ChangePasswordState copyWith({
    FormzStatus status,
    ChangePasswordCurrentPassword currentPassword,
    ChangePasswordNewPassword newPassword,
    ChangePasswordConfirmPassword confirmPassword,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object> get props => [
        status,
        currentPassword,
        newPassword,
        confirmPassword,
      ];
}

class ChangePasswordSuccefulState extends ChangePasswordState {
  ChangePasswordSuccefulState({this.successMessage});

  final String successMessage;
  @override
  List<Object> get props => <dynamic>[successMessage];
}

class RemoteValidationErrorState extends ChangePasswordState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  @override
  List<Object> get props => [remoteValidationErrorMessage];
}

class RemoteServerErrorState extends ChangePasswordState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorState extends ChangePasswordState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  @override
  List<Object> get props => [remoteClientErrorMessage];
}

class CurrentPasswordVisibilityChangedState extends ChangePasswordState {
  const CurrentPasswordVisibilityChangedState({this.visibility});

  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class NewPasswordVisibilityChangedState extends ChangePasswordState {
  const NewPasswordVisibilityChangedState({this.visibility});

  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class ConfirmPasswordVisibilityChangedState extends ChangePasswordState {
  const ConfirmPasswordVisibilityChangedState({this.visibility});

  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class InputsValidatedState extends ChangePasswordState {
  const InputsValidatedState();

  @override
  List<Object> get props => [];
}
