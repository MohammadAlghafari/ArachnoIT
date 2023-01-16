part of 'notification_bloc.dart';

enum NotificationProviderStatus {
  initial,
  loading,
  success,
  failure,
  readNotification,
  successReadNotification,
  failureReadNotification,
  successReadAllNotifications,
  failedReadAllNotification,
}

@immutable
class NotificationState {
  const NotificationState({
    this.status = NotificationProviderStatus.initial,
    this.notifications = const <PersonNotification>[],
    this.hasReachedMax = false,
    this.isRead = false,
  });

  final NotificationProviderStatus status;
  final List<PersonNotification> notifications;
  final bool hasReachedMax;
  final bool isRead;
  NotificationState copyWith({
    NotificationProviderStatus status,
    List<PersonNotification> notifications,
    bool hasReachedMax,
    bool isRead,
  }) {
    return NotificationState(
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
