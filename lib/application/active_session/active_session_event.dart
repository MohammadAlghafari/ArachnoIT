part of 'active_session_bloc.dart';

abstract class ActiveSessionEvent extends Equatable {
  const ActiveSessionEvent();

  @override
  List<Object> get props => [];
}

class GetALlActiveSessionEvent extends ActiveSessionEvent {
 final bool isRefreshData;
 GetALlActiveSessionEvent({this.isRefreshData=false});
}

class SendReportEvent extends ActiveSessionEvent {
  final String itemId;
  final BuildContext context;
  final String message;
  SendReportEvent({this.itemId, this.context, this.message});
}
