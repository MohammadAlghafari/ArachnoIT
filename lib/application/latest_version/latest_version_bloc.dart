import 'dart:async';

import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/latest_version/response/latest_version_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/main.dart';
import 'package:arachnoit/presentation/screens/latest_apk/latest_apk_screen.dart';
import 'package:arachnoit/presentation/screens/main/main_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:package_info/package_info.dart';
part 'latest_version_event.dart';
part 'latest_version_state.dart';

class LatestVersionBloc extends Bloc<LatestVersionEvent, LatestVersionState> {
  LatestVersionBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(LatestVersionInitial());

  final CatalogFacadeService catalogService;
  @override
  Stream<LatestVersionState> mapEventToState(LatestVersionEvent event) async* {
    if (event is CheckVersion) {
      try {
        if (AppConst.CHECKED_VERSION_APP == null)
          AppConst.CHECKED_VERSION_APP = false;

        final ResponseWrapper<LatestVersionResponse> response =
            await catalogService.getLatestVersion();

        if (response.responseType == ResType.ResponseType.SUCCESS) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          String buildNumber = packageInfo.buildNumber;
          AppConst.CHECKED_VERSION_APP = true;
          if (response.data.lastNormalVersion == null) {
            // int.parse(buildNumber)
            if (100000 < response.data.lastAggressiveVersion.versionCode) {
              navigatorKey.currentState
                  .pushNamedAndRemoveUntil(LatestApkScreen.routeName, (x) {
                return false;
              }, arguments: true);
              yield SuccessGetVersion();
              return;
            } else {
              yield GoingToMainScreen();
              return;
            }
          } else {
            if (100000 < response.data.lastNormalVersion.versionCode) {
              navigatorKey.currentState
                  .pushNamedAndRemoveUntil(LatestApkScreen.routeName, (x) {
                return true;
              }, arguments: false);
              yield SuccessGetVersion();
              return;
            } else {
              yield GoingToMainScreen();
              return;
            }
          }
        } else {
          yield GoingToMainScreen();
          return;
        }
      } catch (e) {
        yield GoingToMainScreen();
        return;
      }
    }
  }
}
