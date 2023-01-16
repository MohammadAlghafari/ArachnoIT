part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetUserNotificationEvent extends NotificationEvent {
  final bool isRefreshData;
  final bool reloadData;
  final BuildContext context;
  GetUserNotificationEvent({@required this.isRefreshData, this.reloadData = false,@required this.context});
}

class ReadUserNotificationEvent extends NotificationEvent {
  final List<String> notificationId;
  final int selectedNotificationIndex;
  ReadUserNotificationEvent(
      {@required this.notificationId, @required this.selectedNotificationIndex});
  @override
  List<Object> get props => [notificationId];
}

class ReadAllNotifications extends NotificationEvent {
  final String personId;
  final BuildContext context;
  ReadAllNotifications({@required this.personId,@required this.context});
}
