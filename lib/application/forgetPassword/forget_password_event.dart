part of 'forget_password_bloc.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent(
    
  );

  @override
  List<Object> get props => [];
}



class ResetPasswordEvent extends ForgetPasswordEvent {
  const ResetPasswordEvent({this.newPassword,this.confirmPassword,this.email,this.token});
  final String newPassword;
  final String confirmPassword;
  final String email;
  final String token;

  @override
  List<Object> get props => [email,token];
}

class NewPasswordChangedEvent extends ForgetPasswordEvent {
  const NewPasswordChangedEvent({this.newPassword});

  final String newPassword;

  @override
  List<Object> get props => [newPassword];
}

class ConfirmPasswordChangedEvent extends ForgetPasswordEvent {
  const ConfirmPasswordChangedEvent({this.newPassword,this.confirmPassword});

  final String newPassword;
  final String confirmPassword;

  @override
  List<Object> get props => [newPassword,confirmPassword];
}

class ValidateInputsEvent extends ForgetPasswordEvent {
  const ValidateInputsEvent({this.newPassword,this.confirmPassword});

  final String newPassword;
  final String confirmPassword;

  @override
  List<Object> get props => [newPassword,confirmPassword];
}

class NewPasswordVisibilityChangedEvent extends ForgetPasswordEvent {
  const NewPasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;

  @override
  List<Object> get props => [visibility];
}

class ConfirmPasswordVisibilityChangedEvent extends ForgetPasswordEvent {
  const ConfirmPasswordVisibilityChangedEvent({this.visibility});
  
  final bool visibility;

  @override
  List<Object> get props => [visibility];
}
