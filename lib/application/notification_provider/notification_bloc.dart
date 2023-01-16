import 'dart:async';
import 'package:arachnoit/application/main/main_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/notification/response/get_notification_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

part 'notification_event.dart';
part 'notification_state.dart';

const _notification_limits = 10;

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  CatalogFacadeService catalogFacadeService;

  NotificationBloc({@required this.catalogFacadeService})
      : assert(catalogFacadeService != null),
        super(const NotificationState());

  @override
  Stream<Transition<NotificationEvent, NotificationState>> transformEvents(
    Stream<NotificationEvent> events,
    TransitionFunction<NotificationEvent, NotificationState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is GetUserNotificationEvent) {
      yield* _mapGetNotificationInfo(state, event);
    } else if (event is ReadUserNotificationEvent) {
      yield state.copyWith(status: NotificationProviderStatus.readNotification);
      yield await _mapReadNotificationInfo(event, state);
    } else if (event is ReadAllNotifications) {
      yield* _mapReadAllNotifications(event);
    }
  }

  Stream<NotificationState> _mapReadAllNotifications(
    ReadAllNotifications event,
  ) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<bool> readNotificationResponse =
          await catalogFacadeService.readAllNotifications(personId: event.personId);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      if (ResType.ResponseType.SUCCESS == readNotificationResponse.responseType) {
        for (int index = 0; index < state.notifications.length; index++) {
          state.notifications[index].isRead = true;
        }
        MainBloc manBloc =  BlocProvider.of(event.context);
        SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
        manBloc.add(ChangeNumberOfUnReadNotiications(unReadMessage: 0));
        sharedPreferences.setInt(PrefsKeys.UN_READ_MESSAGE, 0);
        yield state.copyWith(status: NotificationProviderStatus.successReadAllNotifications);
        return;
      } else {
        yield state.copyWith(status: NotificationProviderStatus.failedReadAllNotification);
        return;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield state.copyWith(status: NotificationProviderStatus.failedReadAllNotification);
    }
  }

  Future<NotificationState> _mapReadNotificationInfo(
    ReadUserNotificationEvent event,
    NotificationState state,
  ) async {
    try {
      final readNotificationResponse = await _postReadNotifications(event, state);
      List<PersonNotification> items = state.notifications;
      items[event.selectedNotificationIndex].isRead = true;
      return state.copyWith(
          status: NotificationProviderStatus.successReadNotification,
          isRead: readNotificationResponse,
          notifications: items);
    } catch (e) {
      return state.copyWith(
        status: NotificationProviderStatus.failureReadNotification,
      );
    }
  }

  Future<bool> _postReadNotifications(
    ReadUserNotificationEvent event,
    NotificationState state,
  ) async {
    try {
      final ResponseWrapper<bool> readNotificationResponse =
          await catalogFacadeService.readNotificationInfo(
        notificationId: event.notificationId,
      );
      switch (readNotificationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          return readNotificationResponse.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          break;
        case ResType.ResponseType.SERVER_ERROR:
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          break;
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching notifications');
    } catch (e) {
      throw Exception('error fetching notifications');
    }
  }

  Stream<NotificationState> _mapGetNotificationInfo(
      NotificationState state, GetUserNotificationEvent event) async* {
    if (state.hasReachedMax && !event.reloadData) {
      yield state;
      return;
    }
    try {
      if (state.status == NotificationProviderStatus.initial || event.reloadData) {
        yield state.copyWith(status: NotificationProviderStatus.loading);
        final notifications = await _fetchNotifications(event.context,);
        yield state.copyWith(
          status: NotificationProviderStatus.success,
          notifications: notifications,
          hasReachedMax: _hasReachedMax(notifications.length),
        );
        return;
      }
      final notifications =
          await _fetchNotifications(event.context,(state.notifications.length / _notification_limits).round());
      if (event.isRefreshData) {
        yield state.copyWith(
            hasReachedMax: false,
            notifications: notifications,
            status: NotificationProviderStatus.success);
        return;
      }
      yield notifications.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: NotificationProviderStatus.success,
              notifications: state.notifications..addAll(notifications),
              hasReachedMax: _hasReachedMax(notifications.length),
            );
      return;
    } catch (e) {
      print("the error is $e");
      yield state.copyWith(status: NotificationProviderStatus.failure);
      return;
    }
  }

  Future<List<PersonNotification>> _fetchNotifications(BuildContext context,[int startIndex = 0]) async {
    try {
      final response = await catalogFacadeService.getNotificationInfo(
        pageNumber: startIndex,
        pageSize: _notification_limits,
        userId: GlobalPurposeFunctions.getUserObject().userId,
        enablePagenation: true,
        getReadOnly: false,
        getUnReadOnly: false,
      );
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          MainBloc manBloc = BlocProvider.of(context);
          manBloc.add(ChangeNumberOfUnReadNotiications(unReadMessage: response.data.unreadCount));
          SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
          sharedPreferences.setInt(PrefsKeys.UN_READ_MESSAGE, response.data.unreadCount);
          return response.data.personNotifications;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching notifications');
    } on Exception catch (_) {
      throw Exception('error fetching notifications');
    }
  }

  bool _hasReachedMax(int notificationsCount) =>
      notificationsCount < _notification_limits ? true : false;
}
