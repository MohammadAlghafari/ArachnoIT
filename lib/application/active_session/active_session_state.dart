part of 'active_session_bloc.dart';

abstract class ActiveSessionState  {
  const ActiveSessionState();

}

class ActiveSessionInitial extends ActiveSessionState {}

class LoadingSendReport extends ActiveSessionState {}

class SendReportSuccess extends ActiveSessionState {
 final String message;
 SendReportSuccess({this.message});
}

class FailedSendReport extends ActiveSessionState {
 final String message;
 FailedSendReport({this.message});
}

class GelAllActiveSessionSuccess extends ActiveSessionState {
  final List<ActiveSessionModel> activeSeeions;
  GelAllActiveSessionSuccess({this.activeSeeions});
}

class LoadingState extends ActiveSessionState {}

class RemoteValidationErrorState extends ActiveSessionState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends ActiveSessionState {
  RemoteServerErrorState({this.remoteServerErrorMessage});
  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ActiveSessionState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}
