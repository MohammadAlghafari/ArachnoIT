import 'dart:async';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const VerificationState());

  final CatalogFacadeService catalogService;

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    if (event is ClipboardDetectedEvent)
      yield ClipboardDetectedState(code: event.code);
    else if (event is SendActivationCodeEvent)
      yield* _mapSendActivationCodeToState();
    else if (event is ConfirmRegistrationEvent)
      yield* _mapconfirmRegistrationToState(event);
  }

  Stream<VerificationState> _mapSendActivationCodeToState() async* {
    try {
      yield LoadingState();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString(PrefsKeys.EMAIL);
      String phoneNumber = prefs.getString(PrefsKeys.PHONE_NUMBER);

      final ResponseWrapper<bool> sendActivationCodeResponse =
          await catalogService.sendActivationCode(
        email: email,
        phoneNumber: phoneNumber,
      );
      switch (sendActivationCodeResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield ActivationCodeSentState();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage:
                sendActivationCodeResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: sendActivationCodeResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }

  Stream<VerificationState> _mapconfirmRegistrationToState(
      ConfirmRegistrationEvent event) async* {
    try {
      yield LoadingState();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString(PrefsKeys.EMAIL);

      final ResponseWrapper<bool> confirmRegistrationResponse =
          await catalogService.confirmRegistration(
        email: email,
        activationCode: event.activationCode,
      );
      switch (confirmRegistrationResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          if (confirmRegistrationResponse.data){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(PrefsKeys.IS_VERIFIED, true);
            yield ConfirmedRegistrationState();}
          else
            yield WrongActivationCodeState();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage:
                confirmRegistrationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: confirmRegistrationResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
         yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }
}
