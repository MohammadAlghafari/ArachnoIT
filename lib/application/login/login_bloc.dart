import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../domain/login/local/email_or_mobile.dart';
import '../../domain/login/local/forget_password_email.dart';
import '../../domain/login/local/password.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/login/response/login_response.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const LoginState());

  final CatalogFacadeService catalogService;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEmailOrMobileChanged) {
      yield _mapEmailOrMobileChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is ValidateInputsEvent)
      yield _mapValidateInputsToState(event, state);
    else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    } else if (event is LoginForgetPasswordEmailChanged)
      yield _mapLoginForgetPasswordChangedToState(event, state);
    else if (event is LoginForgetPasswordSubmitted)
      yield* _mapLoginForgetPasswordSubmittedToState(event, state);
    else if (event is PasswordVisibilityChangedEvent)
      yield PasswordVisibilityChangedState(visibility: !event.visibility);
  }

  LoginState _mapEmailOrMobileChangedToState(
    LoginEmailOrMobileChanged event,
    LoginState state,
  ) {
    final emailOrMobile = EmailOrMobile.dirty(event.emailOrMobile);
    return state.copyWith(
      emailOrMobile: emailOrMobile,
      status: Formz.validate([state.password, emailOrMobile]),
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.emailOrMobile]),
    );
  }

  LoginState _mapValidateInputsToState(
    ValidateInputsEvent event,
    LoginState state,
  ) {
    final password = Password.dirty(event.password);
    final emailOrMobile = EmailOrMobile.dirty(event.emailOrMobile);

    state = state.copyWith(
      emailOrMobile: emailOrMobile,
      status: Formz.validate([emailOrMobile, state.password]),
    );
    if (state.emailOrMobile.invalid) return state;
    state = state.copyWith(
      password: password,
      status: Formz.validate([state.emailOrMobile, password]),
    );
    if (state.password.invalid)
      return state;
    else
      return InputsValidatedState();
  }

  LoginState _mapLoginForgetPasswordChangedToState(
    LoginForgetPasswordEmailChanged event,
    LoginState state,
  ) {
    final email = ForgetPasswordEmail.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([email]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    try {
      AndroidDeviceInfo mobileInfo;
      String wifiIP = "";
      mobileInfo = await GlobalPurposeFunctions.initPlatformState();
      wifiIP = await GlobalPurposeFunctions.getIpAddress();
      final ResponseWrapper<LoginResponse> loginResponse = await catalogService.loginIntoServer(
          email: event.emailOrMobile,
          password: event.password,
          model:  mobileInfo.model  ,
          product:  mobileInfo.model,
          brand:  mobileInfo.model,
          ip: wifiIP,
          osApiLevel: mobileInfo.version.sdkInt);
      switch (loginResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefsKeys.LOGIN_RESPONSE, loginResponse.data.toJson());
          prefs.setString(PrefsKeys.TOKEN, loginResponse.data.accessToken);
          prefs.setBool(PrefsKeys.IS_VERIFIED, true);
          prefs.setString(PrefsKeys.CULTURE_CODE, loginResponse.data.cultureCode);
          Map<String, bool> map = {};
          prefs.setString(PrefsKeys.ENCODED_GROUP_HINT_MAP, jsonEncode(map));

          yield LoginSuccefulState(
            successMessage: loginResponse.successMessage,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: loginResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          if (loginResponse.enumResult == 4)
            yield AccountNeedsActivationState();
          else
            yield RemoteServerErrorState(
              remoteServerErrorMessage: loginResponse.errorMessage,
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

  Stream<LoginState> _mapLoginForgetPasswordSubmittedToState(
    LoginForgetPasswordSubmitted event,
    LoginState state,
  ) async* {
    yield LoginRequestResetPasswordLoadingState();
    try {
      final ResponseWrapper<bool> requestResetPassword = await catalogService.requestResetPassword(
        email: event.email,
      );
      switch (requestResetPassword.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield LoginRequestResetPasswordSuccefulState(
            successMessage: requestResetPassword.successMessage,
          );
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: requestResetPassword.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: requestResetPassword.errorMessage,
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
