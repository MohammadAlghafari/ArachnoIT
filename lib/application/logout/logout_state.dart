part of 'logout_bloc.dart';

 class LogoutState  {
  const LogoutState();
  
}

class UserLoggedoutState extends LogoutState {}
class LoadingLogoutState extends LogoutState {}

class RemoteLogoutValidationErrorState extends LogoutState {
  RemoteLogoutValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteLogoutServerErrorState extends LogoutState {
  RemoteLogoutServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteLogoutClientErrorState extends LogoutState {
  RemoteLogoutClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}
