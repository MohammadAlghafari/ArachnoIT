part of 'local_auth_bloc.dart';

 class LocalAuthState extends Equatable {
  const LocalAuthState({
    this.hasBiometrics = false,
    this.authenticated = false,
    this.authenticationFinished =false,
  });
  final bool hasBiometrics ;
  final bool authenticated;
  final bool authenticationFinished;

  LocalAuthState copyWith({
   bool hasBiometrics,
   bool authenticated,
   bool authenticationFinished,
  }) {
    return LocalAuthState(
      hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      authenticated: authenticated ?? this.authenticated,
      authenticationFinished: authenticationFinished ?? this.authenticationFinished,
    );
  }


  @override
  List<Object> get props => [hasBiometrics, authenticated];
}

