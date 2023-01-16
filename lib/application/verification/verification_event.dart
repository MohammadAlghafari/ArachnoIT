part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object> get props => [];
}

class ClipboardDetectedEvent extends VerificationEvent {
  const ClipboardDetectedEvent(this.code);
  final String code;
  @override
  List<Object> get props => [code];
}

class ConfirmRegistrationEvent extends VerificationEvent {
  const ConfirmRegistrationEvent(this.activationCode);
  final String activationCode;
  @override
  List<Object> get props => [activationCode];
}

class SendActivationCodeEvent extends VerificationEvent {
  const SendActivationCodeEvent();
  @override
  List<Object> get props => [];
}
