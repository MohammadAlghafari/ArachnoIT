part of 'verification_bloc.dart';

class VerificationState extends Equatable {
  const VerificationState();
  
  @override
  List<Object> get props => [];
}

class RemoteValidationErrorState extends VerificationState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  @override
  List<Object> get props => [remoteValidationErrorMessage];
}

class RemoteServerErrorState extends VerificationState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorState extends VerificationState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  @override
  List<Object> get props => [remoteClientErrorMessage];
}
class LoadingState extends VerificationState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class ClipboardDetectedState extends VerificationState {
  ClipboardDetectedState({this.code});
  final String code;
  @override
  List<Object> get props => [code];
}

class ConfirmedRegistrationState extends VerificationState {
  ConfirmedRegistrationState();
  @override
  List<Object> get props => [];
}

class ActivationCodeSentState extends VerificationState {
  ActivationCodeSentState();
  @override
  List<Object> get props => [];
}

class WrongActivationCodeState extends VerificationState {
  WrongActivationCodeState();
  @override
  List<Object> get props => [];
}
