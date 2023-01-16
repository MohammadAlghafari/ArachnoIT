import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../domain/forgetPassword/local/forget_password_confirm_password.dart';
import '../../domain/forgetPassword/local/forget_password_password.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const ForgetPasswordState());

  final CatalogFacadeService catalogService;

  @override
  Stream<ForgetPasswordState> mapEventToState(
    ForgetPasswordEvent event,
  ) async* {
    if (event is NewPasswordChangedEvent) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is ConfirmPasswordChangedEvent) {
      yield _mapConfirmPasswordChangedToState(event, state);
    } else if (event is ResetPasswordEvent)
      yield* _mapResetPasswordSubmittedToState(event, state);
    else if (event is ValidateInputsEvent)
      yield _mapValidateInputsToState(event, state);
    else if (event is NewPasswordVisibilityChangedEvent)
      yield NewPasswordVisibilityChangedState(visibility: !event.visibility);
    else if (event is ConfirmPasswordVisibilityChangedEvent)
      yield ConfirmPasswordVisibilityChangedState(
          visibility: !event.visibility);
  }

  ForgetPasswordState _mapPasswordChangedToState(
    NewPasswordChangedEvent event,
    ForgetPasswordState state,
  ) {
    final newPassword = ForgetPasswordPassword.dirty(event.newPassword);
    return state.copyWith(
      newPassword: newPassword,
      status: Formz.validate([newPassword, state.confirmPassword]),
    );
  }

  ForgetPasswordState _mapConfirmPasswordChangedToState(
    ConfirmPasswordChangedEvent event,
    ForgetPasswordState state,
  ) {
    final confirmPassword = ForgetPasswordConfirmPassword.dirty(
        [event.newPassword, event.confirmPassword]);
    return state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([state.newPassword, confirmPassword]),
    );
  }

  ForgetPasswordState _mapValidateInputsToState(
    ValidateInputsEvent event,
    ForgetPasswordState state,
  ) {
    final newPassword = ForgetPasswordPassword.dirty(event.newPassword);
    final confirmPassword = ForgetPasswordConfirmPassword.dirty(
        [event.confirmPassword, event.newPassword]);

    state = state.copyWith(
      newPassword: newPassword,
      status: Formz.validate([newPassword, state.confirmPassword]),
    );
    if (state.newPassword.invalid) return state;
    state = state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([state.newPassword, confirmPassword]),
    );
    if (state.confirmPassword.invalid)
      return state;
    else
      return InputsValidatedState();
  }

  Stream<ForgetPasswordState> _mapResetPasswordSubmittedToState(
    ResetPasswordEvent event,
    ForgetPasswordState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      final ResponseWrapper<bool> resetPasswordResponse =
          await catalogService.resetPassword(
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        email: event.email,
        token: event.token,
      );
      switch (resetPasswordResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          if (resetPasswordResponse.data)
            yield ResetPasswordSuccefulState(
                successMessage: resetPasswordResponse.successMessage);
          else
            yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: resetPasswordResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: resetPasswordResponse.errorMessage,
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
