import 'dart:async';

import '../../common/pref_keys.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_auth_event.dart';
part 'local_auth_state.dart';

class LocalAuthBloc extends Bloc<LocalAuthEvent, LocalAuthState> {
  LocalAuthBloc() : super(LocalAuthState());
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Stream<LocalAuthState> mapEventToState(
    LocalAuthEvent event,
  ) async* {
    if (event is CheckBiometricsEvent) {
      yield* _mapCheckBiometricsToState(state);
    } else if (event is AuthenticatEvent)
      yield* _mapAuthenticateToState(event, state);
    else if (event is UnAuthenticatEvent)
      yield* _mapUnAuthenticateToState(state);
  }

  Stream<LocalAuthState> _mapCheckBiometricsToState(
    LocalAuthState state,
  ) async* {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool authenticated = prefs.getBool(PrefsKeys.AUTHENTICATED);
      yield state.copyWith(
          hasBiometrics: canCheckBiometrics,
          authenticated: authenticated != null ? authenticated : false);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Stream<LocalAuthState> _mapAuthenticateToState(
    AuthenticatEvent event,
    LocalAuthState state,
  ) async* {
    var iosStrings = IOSAuthMessages(
      cancelButton: AppLocalizations.of(event.context).cancel,
      goToSettingsButton: AppLocalizations.of(event.context).settings,
    );
    var androidStrings = AndroidAuthMessages(
      cancelButton: AppLocalizations.of(event.context).cancel,
      goToSettingsButton: AppLocalizations.of(event.context).settings,
      biometricHint:AppLocalizations.of(event.context).security,
      signInTitle: AppLocalizations.of(event.context).authentication,
    );
    try {
      bool authenticated = await auth.authenticateWithBiometrics(
          localizedReason: AppLocalizations.of(event.context)
          .place_your_finger_on_the_device_home_button_to_verify_your_identity,
          useErrorDialogs: true,
          stickyAuth: true,
          androidAuthStrings: androidStrings,
          iOSAuthStrings: iosStrings);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(PrefsKeys.AUTHENTICATED, authenticated);
      yield state.copyWith(
          hasBiometrics: state.hasBiometrics,
          authenticated: authenticated,
          authenticationFinished: true);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Stream<LocalAuthState> _mapUnAuthenticateToState(
    LocalAuthState state,
  ) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PrefsKeys.AUTHENTICATED, false);
    yield state.copyWith(
      hasBiometrics: state.hasBiometrics,
      authenticated: false,
       authenticationFinished: false,
    );
  }
}
