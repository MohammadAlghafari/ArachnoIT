import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const LogoutState());

  final CatalogFacadeService catalogService;

  @override
  Stream<LogoutState> mapEventToState(
    LogoutEvent event,
  ) async* {
    if (event is LogoutUserEvent) yield* _mapLogoutSubmittedToState(event);
  }

  Stream<LogoutState> _mapLogoutSubmittedToState(
    LogoutUserEvent event,
  ) async* {
    yield LoadingLogoutState();
    try {
      final ResponseWrapper<bool> logoutResponse =
          await catalogService.logoutUser(
              model: "null",
              product: "null",
              brand: "null",
              ip: "null",
              osApiLevel: 0);
      switch (logoutResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove(
            PrefsKeys.LOGIN_RESPONSE,
          );
          prefs.remove(
            PrefsKeys.TOKEN,
          );

          yield UserLoggedoutState();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteLogoutValidationErrorState(
            remoteValidationErrorMessage: logoutResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteLogoutServerErrorState(
            remoteServerErrorMessage: logoutResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteLogoutClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } on Exception catch (_) {}
  }
}
