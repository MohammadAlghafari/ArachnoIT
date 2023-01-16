part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class CurrentPasswordChangedEvent extends ChangePasswordEvent {
  const CurrentPasswordChangedEvent({this.currentPassword});

  final String currentPassword;

  @override
  List<Object> get props => [currentPassword];
}

class NewPasswordChangedEvent extends ChangePasswordEvent {
  const NewPasswordChangedEvent({this.currentPassword,this.newPassword});

  final String currentPassword;
  final String newPassword;

  @override
  List<Object> get props => [currentPassword,newPassword];
}
class ConfirmPasswordChangedEvent extends ChangePasswordEvent {
  const ConfirmPasswordChangedEvent({this.newPassword,this.confirmPassword});

  final String newPassword;
  final String confirmPassword;

  @override
  List<Object> get props => [newPassword,confirmPassword];
}

class ValidateInputsEvent extends ChangePasswordEvent {
  const ValidateInputsEvent({this.currentPassword,this.newPassword,this.confirmPassword});

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  @override
  List<Object> get props => [currentPassword,newPassword,confirmPassword];
}

class ChangePasswordSubmittedEvent extends ChangePasswordEvent {
  const ChangePasswordSubmittedEvent({this.currentPassword,this.newPassword,this.confirmPassword});
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  @override
  List<Object> get props => [currentPassword,newPassword,confirmPassword];
}

class CurrentPasswordVisibilityChangedEvent extends ChangePasswordEvent {
  const CurrentPasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class NewPasswordVisibilityChangedEvent extends ChangePasswordEvent {
  const NewPasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class ConfirmPasswordVisibilityChangedEvent extends ChangePasswordEvent {
  const ConfirmPasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;

  @override
  List<Object> get props => [visibility];
}
