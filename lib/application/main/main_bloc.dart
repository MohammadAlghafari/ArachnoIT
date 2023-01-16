import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/common/check_user_login.dart';
import 'package:arachnoit/injections.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/main/local/Main_tabs.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/catalog_facade_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(MainState());

  final CatalogFacadeService catalogService;
  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is MainTabUpdated) {
      yield state.copyWith(tab: event.tab);
    } else if (event is MainLoggedOutTabUpdated) {
      yield state.copyWith(loggedOutTab: event.loggedOutTab);
    } else if (event is ChangeLoginStatus) {
      yield state.copyWith(isUserLogin: event.currentValue);
    } else if (event is ChangeImage) {
      yield state.copyWith(image: event.image);
    } else if (event is ChangeNumberOfUnReadNotiications) {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      sharedPreferences.setInt(
          PrefsKeys.UN_READ_MESSAGE, event.unReadMessage);
      yield state.copyWith(unReadNotificationCount: event.unReadMessage);
    } else if (event is IncreaseOrDicreaseNotification) {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      sharedPreferences.setInt(PrefsKeys.UN_READ_MESSAGE,  state.unReadNotificationCount + event.countOfIncrease);
      yield state.copyWith(
          unReadNotificationCount: state.unReadNotificationCount + event.countOfIncrease);
    }
  }
}
