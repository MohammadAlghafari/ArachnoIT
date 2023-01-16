import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../domain/changePassword/change_password_confirm_password.dart';
import '../../domain/changePassword/change_password_current_password.dart';
import '../../domain/changePassword/change_password_new_password.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const ChangePasswordState());

  final CatalogFacadeService catalogService;

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is CurrentPasswordChangedEvent)
      yield _mapCurrentPasswordChangedToState(event, state);
    else if (event is NewPasswordChangedEvent)
      yield _mapNewPasswordChangedToState(event, state);
    else if (event is ConfirmPasswordChangedEvent)
      yield _mapConfirmPasswordChangedToState(event, state);
    else if (event is ChangePasswordSubmittedEvent)
      yield* _mapChangePasswordSubmittedToState(event, state);
    else if (event is ValidateInputsEvent)
      yield _mapValidateInputsToState(event, state);
    else if (event is CurrentPasswordVisibilityChangedEvent)
      yield CurrentPasswordVisibilityChangedState(
          visibility: !event.visibility);
    else if (event is NewPasswordVisibilityChangedEvent)
      yield NewPasswordVisibilityChangedState(visibility: !event.visibility);
    else if (event is ConfirmPasswordVisibilityChangedEvent)
      yield ConfirmPasswordVisibilityChangedState(
          visibility: !event.visibility);
  }

  ChangePasswordState _mapCurrentPasswordChangedToState(
    CurrentPasswordChangedEvent event,
    ChangePasswordState state,
  ) {
    final currentPassword =
        ChangePasswordCurrentPassword.dirty(event.currentPassword);
    return state.copyWith(
      currentPassword: currentPassword,
      status: Formz.validate(
          [currentPassword, state.newPassword, state.confirmPassword]),
    );
  }

  ChangePasswordState _mapNewPasswordChangedToState(
    NewPasswordChangedEvent event,
    ChangePasswordState state,
  ) {
    final newPassword = ChangePasswordNewPassword.dirty(
        [event.newPassword, event.currentPassword]);
    return state.copyWith(
      newPassword: newPassword,
      status: Formz.validate(
          [state.currentPassword, newPassword, state.confirmPassword]),
    );
  }

  ChangePasswordState _mapConfirmPasswordChangedToState(
    ConfirmPasswordChangedEvent event,
    ChangePasswordState state,
  ) {
    final confirmPassword = ChangePasswordConfirmPassword.dirty(
        [event.confirmPassword, event.newPassword]);
    return state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate(
          [state.currentPassword, state.newPassword, confirmPassword]),
    );
  }

  ChangePasswordState _mapValidateInputsToState(
    ValidateInputsEvent event,
    ChangePasswordState state,
  ) {
    final currentPassword =
        ChangePasswordCurrentPassword.dirty(event.currentPassword);
    final newPassword = ChangePasswordNewPassword.dirty(
        [event.newPassword, event.currentPassword]);
    final confirmPassword = ChangePasswordConfirmPassword.dirty(
        [event.confirmPassword, event.newPassword]);
    state = state.copyWith(
      currentPassword: currentPassword,
      status: Formz.validate(
          [currentPassword, state.newPassword, state.confirmPassword]),
    );
    if (state.currentPassword.invalid) return state;
    state = state.copyWith(
      newPassword: newPassword,
      status: Formz.validate(
          [state.currentPassword, newPassword, state.confirmPassword]),
    );
    if (state.newPassword.invalid) return state;
    state = state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate(
          [state.currentPassword, state.newPassword, confirmPassword]),
    );
    if (state.newPassword.invalid)
      return state;
    else
      return InputsValidatedState();
  }

  Stream<ChangePasswordState> _mapChangePasswordSubmittedToState(
    ChangePasswordSubmittedEvent event,
    ChangePasswordState state,
  ) async* {
    
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        final ResponseWrapper<bool> changePasswordResponse =
            await catalogService.changePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
        );
        switch (changePasswordResponse.responseType) {
          case ResType.ResponseType.SUCCESS:
            if (changePasswordResponse.data) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove(PrefsKeys.LOGIN_RESPONSE);
              prefs.remove(PrefsKeys.TOKEN);
              prefs.setBool(PrefsKeys.IS_VERIFIED, false);
              yield ChangePasswordSuccefulState(
                  successMessage: changePasswordResponse.successMessage);
            } else
              yield RemoteClientErrorState();
            break;
          case ResType.ResponseType.VALIDATION_ERROR:
            yield RemoteValidationErrorState(
              remoteValidationErrorMessage: changePasswordResponse.errorMessage,
            );
            break;
          case ResType.ResponseType.SERVER_ERROR:
            yield RemoteServerErrorState(
              remoteServerErrorMessage: changePasswordResponse.errorMessage,
            );
            break;
          case ResType.ResponseType.CLIENT_ERROR:
            yield RemoteClientErrorState();
            break;
          case ResType.ResponseType.NETWORK_ERROR:
            break;
        }
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      
    }
  }
}
