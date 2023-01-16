import 'dart:async';

import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/injections.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;

import '../../common/pref_keys.dart';
import '../../infrastructure/catalog_facade_service.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const LanguageState());

  final CatalogFacadeService catalogService;

  @override
  Stream<LanguageState> mapEventToState(
    LanguageEvent event,
  ) async* {
    if (event is LanguageInitialEvent)
      yield* _mapLanguageInitialToState();
    else if (event is LanguageChangedEvent) yield* _mapLanguageChangedToState(event);
  }

  Stream<LanguageState> _mapLanguageInitialToState() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sharedLang = prefs.get(PrefsKeys.CULTURE_CODE);
    if (sharedLang != null) {
      yield LanguageInitialState(language: sharedLang);
    } else {
      prefs.setString(PrefsKeys.CULTURE_CODE, 'en-US');
      yield LanguageInitialState(language: 'en-US');
    }
  }

  Stream<LanguageState> _mapLanguageChangedToState(
    LanguageChangedEvent event,
  ) async* {
    SharedPreferences prefs = serviceLocator<SharedPreferences>();
    dynamic sharedLang = prefs.get(PrefsKeys.CULTURE_CODE);
    dynamic loginResponse = prefs.get(PrefsKeys.LOGIN_RESPONSE);
    if (sharedLang == event.language || sharedLang == null) {
      prefs.setString(PrefsKeys.CULTURE_CODE, event.language);
      yield SameLanguageSelectedState(language: event.language);
    } else {
      if (loginResponse != null) {
        try {
          yield LoadingState();
          final ResponseWrapper<bool> languageResponse = await catalogService.setLanguage();
          switch (languageResponse.responseType) {
            case ResType.ResponseType.SUCCESS:
              prefs.setString(PrefsKeys.CULTURE_CODE, event.language);
              yield LanguageChangedState(language: event.language);
              break;
            case ResType.ResponseType.VALIDATION_ERROR:
              yield RemoteValidationErrorState(
                remoteValidationErrorMessage: languageResponse.errorMessage,
              );
              break;
            case ResType.ResponseType.SERVER_ERROR:
              yield RemoteServerErrorState(
                remoteServerErrorMessage: languageResponse.errorMessage,
              );
              break;
            case ResType.ResponseType.CLIENT_ERROR:
              yield RemoteClientErrorState();
              break;
            case ResType.ResponseType.NETWORK_ERROR:
              break;
          }
        } on Exception catch (_) {}
      } else {
        prefs.setString(PrefsKeys.CULTURE_CODE, event.language);
        yield LanguageChangedState(language: event.language);
      }
    }
  }
}
