import 'dart:async';
import 'dart:convert';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/common/social_register.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/infrastructure/registration_socail/response/social_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
part 'registration_socail_event.dart';
part 'registration_socail_state.dart';

class RegistrationSocailBloc extends Bloc<RegistrationSocailEvent, RegistrationSocailState> {
  CatalogFacadeService catalogService;
  AccessToken _accessToken;

  RegistrationSocailBloc({@required this.catalogService}) : super(RegistrationSocailInitial());

  @override
  Stream<RegistrationSocailState> mapEventToState(
    RegistrationSocailEvent event,
  ) async* {
    if (event is ValidateFaceBookTokenEvent) {
      yield* _mapValidateFaceBookToken(event);
    } else if (event is LoginUsingFaceBook) {
      yield* _mapLoginUsingFaceBook(event);
    } else if (event is ValidateGoogleTokenEvent) {
      yield* _mapValidateGoogleTokenEvent(event);
    } else if (event is LoginUsingGoogle) {
      yield* _mapLoginUsingGoogle(event);
    }
  }

  Stream<RegistrationSocailState> _mapLoginUsingGoogle(LoginUsingGoogle event) async* {
    try {
      AndroidDeviceInfo mobileInfo;
      String wifiIP = "";
      mobileInfo = await GlobalPurposeFunctions.initPlatformState();
      wifiIP = await GlobalPurposeFunctions.getIpAddress();
      ResponseWrapper<LoginResponse> loginResponse = await catalogService.sendGoogleLogin(
        token: event.accessToken,
        email: event.email,
        fcmId: "",
        model: mobileInfo.model,
        product: mobileInfo.model,
        brand: mobileInfo.model,
        ip: wifiIP,
        osApiLevel: 0,
        rememberMe: true,
      );
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      if (loginResponse.responseType == ResType.ResponseType.SUCCESS) {
        SharedPreferences prefs = serviceLocator<SharedPreferences>();
        prefs.setString(PrefsKeys.LOGIN_RESPONSE, loginResponse.data.toJson());
        prefs.setString(PrefsKeys.TOKEN, loginResponse.data.accessToken);
        prefs.setBool(PrefsKeys.IS_VERIFIED, true);
        prefs.setString(PrefsKeys.CULTURE_CODE, loginResponse.data.cultureCode);
        Map<String, bool> map = {};
        prefs.setString(PrefsKeys.ENCODED_GROUP_HINT_MAP, jsonEncode(map));
        yield SuccessLogin(successMessage: loginResponse.successMessage);
        return;
      } else {
        GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
        yield ErrorHappened();
        return;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield ErrorHappened();
      return;
    }
  }

  Stream<RegistrationSocailState> _mapLoginUsingFaceBook(LoginUsingFaceBook event) async* {
    try {
      AndroidDeviceInfo mobileInfo;
      String wifiIP = "";
      mobileInfo = await GlobalPurposeFunctions.initPlatformState();
      wifiIP = await GlobalPurposeFunctions.getIpAddress();

      ResponseWrapper<LoginResponse> loginResponse = await catalogService.sendFaceBookLogin(
        token: event.accessToken,
        email: event.email,
        fcmId: "",
        model: mobileInfo.model,
        product: mobileInfo.model,
        brand: mobileInfo.model,
        ip: wifiIP,
        osApiLevel: 0,
        rememberMe: true,
      );
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      if (loginResponse.responseType == ResType.ResponseType.SUCCESS) {
        SharedPreferences prefs = serviceLocator<SharedPreferences>();
        prefs.setString(PrefsKeys.LOGIN_RESPONSE, loginResponse.data.toJson());
        prefs.setString(PrefsKeys.TOKEN, loginResponse.data.accessToken);
        prefs.setBool(PrefsKeys.IS_VERIFIED, true);
        prefs.setString(PrefsKeys.CULTURE_CODE, loginResponse.data.cultureCode);
        Map<String, bool> map = {};
        prefs.setString(PrefsKeys.ENCODED_GROUP_HINT_MAP, jsonEncode(map));
        yield SuccessLogin(successMessage: loginResponse.successMessage);
        return;
      } else {
        GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
        yield ErrorHappened();
        return;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield ErrorHappened();
      return;
    }
  }

  // ---> This Code To Get First And Last Name From Token ID
  static Map<String, dynamic> getUserInfoFromGrooglTokenId(String token) {
    if (token == null) return null;
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  Stream<RegistrationSocailState> _mapValidateGoogleTokenEvent(
      ValidateGoogleTokenEvent event) async* {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount user = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await user.authentication;
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);

      ResponseWrapper<SocialResponse> data =
          await catalogService.validateGoogleToken(token: googleSignInAuthentication.accessToken);

      if (data.responseType == ResType.ResponseType.SUCCESS) {
        // print("the first is ${googleSignInAuthentication.accessToken}");
        // print("the first is ${googleSignInAuthentication.idToken}");

        Map<String, dynamic> idMap =
            getUserInfoFromGrooglTokenId(googleSignInAuthentication.idToken);

        yield SuccessValidateGoogleToken(
            socialResponse: data.data,
            socailRegisterParam: SocailRegisterParam(
                email: user.email ?? "",
                firstName: idMap["given_name"] ?? "",
                lastName: idMap["family_name"] ?? "",
                name: user.displayName ?? "",
                token: googleSignInAuthentication.accessToken ?? ""));

        return;
      } else {
        GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);

        yield FailedValidateFaceBookToken();

        return;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);

      yield ErrorHappened();

      return;
    }
  }

  Stream<RegistrationSocailState> _mapValidateFaceBookToken(
      ValidateFaceBookTokenEvent event) async* {
    String token = await _login();

    if (token.length == 0) {
      yield CanceledFaceBook();

      return;
    }
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);

      ResponseWrapper<SocialResponse> data =
          await catalogService.validateFaceBookToken(token: token);

      if (data.responseType == ResType.ResponseType.SUCCESS) {
        final graphResponse = await http.get(Uri.parse(
            "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,birthday,link,gender,location&access_token=${token}"));

        final profile = json.decode(graphResponse.body);
        print("the teh profile is $profile");

        yield SuccessValidateFaceBookToken(
            socialResponse: data.data,
            socailRegisterParam: SocailRegisterParam(
              email: profile['email'] ?? "",
              firstName: profile['first_name'] ?? '',
              lastName: profile['last_name'] ?? "",
              name: profile['name'] ?? "",
              birthday: profile['birthday'] ?? '',
              gender: profile["gender"] == null
                  ? 0
                  : profile["gender"] == "male"
                      ? 0
                      : 1,
              token: token,
            ));

        return;
      } else {
        GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);

        yield FailedValidateFaceBookToken();

        return;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);

      yield ErrorHappened();

      return;
    }
  }

  Future<String> _login() async {
    final LoginResult result = await FacebookAuth.i.login(
      permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_gender',
        'user_link',
        'user_location'
      ],
    );
    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;
      return _accessToken.token;
    } else {
      return "";
    }
  }
}
