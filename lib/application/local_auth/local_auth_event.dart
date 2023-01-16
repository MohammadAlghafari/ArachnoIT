part of 'local_auth_bloc.dart';

abstract class LocalAuthEvent extends Equatable {
  const LocalAuthEvent();

  @override
  List<Object> get props => [];
}

class CheckBiometricsEvent extends LocalAuthEvent {
  const CheckBiometricsEvent();

  @override
  List<Object> get props => [];
}

class AuthenticatEvent extends LocalAuthEvent {
  const AuthenticatEvent({this.context});
  final BuildContext context;
  @override
  List<Object> get props => [];
}

class UnAuthenticatEvent extends LocalAuthEvent {
  const UnAuthenticatEvent();

  @override
  List<Object> get props => [];
}
