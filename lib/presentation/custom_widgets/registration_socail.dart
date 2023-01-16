import 'dart:io';

import 'package:arachnoit/application/registration_socail/registration_socail_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/screens/registraition/register_business_user_screen.dart';
import 'package:arachnoit/presentation/screens/registraition/register_individual_user_screen.dart';
import 'package:arachnoit/presentation/screens/registraition/register_normal_user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/restart_widget.dart';
import 'package:arachnoit/presentation/screens/main/main_screen.dart';
import 'package:arachnoit/presentation/screens/registraition/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class RegistrationSocail extends StatefulWidget {
  final RegisterationType registerationType;
  RegistrationSocail({this.registerationType = RegisterationType.Null});
  @override
  State<StatefulWidget> createState() => _RegistrationSocail();
}

class _RegistrationSocail extends State<RegistrationSocail> {
  final RegistrationSocailBloc registrationSocailBloc = serviceLocator<RegistrationSocailBloc>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<RegistrationSocailBloc>(
        create: (context) => registrationSocailBloc,
        child: BlocListener<RegistrationSocailBloc, RegistrationSocailState>(
          listener: (context, state) {
            if (state is SuccessValidateFaceBookToken) {
              facebookValid(state, context);
            } else if (state is SuccessLogin) {
              successLogin(state, context);
            } else if (state is SuccessValidateGoogleToken) {
              googleValid(state, context);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: 8, left: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    registrationSocailBloc.add(ValidateFaceBookTokenEvent(context: context));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).continue_with_facebook,
                            style: regularMontserrat(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/images/facebook.svg",
                            width: 30,
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    registrationSocailBloc.add(ValidateGoogleTokenEvent(context: context));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).continue_with_google,
                            style: regularMontserrat(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/images/google_plus_icon.svg",
                            width: 30,
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: SignInWithAppleButton(
                      onPressed: () async {
                        final appleCredential = await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );
                        print("credential credential ");
                        // https://magenta-plant-dragonfruit.glitch.me/callbacks/sign_in_with_apple
                        // This is the endpoint that will convert an authorization code obtained
                        // via Sign in with Apple into a session in your system
                        // final signInWithAppleEndpoint = Uri(
                        //   scheme: 'https',
                        //   host: 'magenta-plant-dragonfruit.glitch.me/callbacks',
                        //   path: '/sign_in_with_apple',
                        //   queryParameters: <String, String>{
                        //     'code': credential.authorizationCode,
                        //     if (credential.givenName != null) 'firstName': credential.givenName,
                        //     if (credential.familyName != null) 'lastName': credential.familyName,
                        //     'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
                        //     if (credential.state != null) 'state': credential.state,
                        //   },
                        // );

                        // final session = await http.Client().post(
                        //   signInWithAppleEndpoint,
                        // );

                        // If we got this far, a session based on the Apple ID credential has been created in your system,
                        // and you can now set this as the app's session
                        // print(session);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void successLogin(SuccessLogin state, BuildContext context) {
    GlobalPurposeFunctions.showToast(state.successMessage, context);
    RestartWidget.of(context).restartApp();
    Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
  }

  void facebookValid(SuccessValidateFaceBookToken state, BuildContext context) {
    if (state.socialResponse.isTokenvalid) {
      if (state.socialResponse.isExist) {
        registrationSocailBloc.add(LoginUsingFaceBook(
            email: state.socailRegisterParam.email,
            accessToken: state.socailRegisterParam.token,
            context: context));
      } else if (!state.socialResponse.isExist) {
        Navigator.of(context).pop();
        if (widget.registerationType == RegisterationType.Null) {
          Navigator.of(context)
              .pushNamed(RegistrationScreen.routeName, arguments: state.socailRegisterParam);
        } else {
          if (widget.registerationType == RegisterationType.NormalUser)
            Navigator.of(context).pushNamed(RegisterNormalUserScreen.routeName,
                arguments: state.socailRegisterParam);
        }
      }
    } else {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(context).invalid_facebook_account, context);
    }
  }

  void googleValid(SuccessValidateGoogleToken state, BuildContext context) {
    if (state.socialResponse.isTokenvalid) {
      if (state.socialResponse.isExist) {
        registrationSocailBloc.add(LoginUsingGoogle(
            email: state.socailRegisterParam.email,
            accessToken: state.socailRegisterParam.token,
            context: context));
      } else if (!state.socialResponse.isExist) {
        Navigator.of(context).pop();
        if (widget.registerationType == RegisterationType.Null) {
          Navigator.of(context)
              .pushNamed(RegistrationScreen.routeName, arguments: state.socailRegisterParam);
        } else {
          if (widget.registerationType == RegisterationType.NormalUser)
            Navigator.of(context).pushNamed(RegisterNormalUserScreen.routeName,
                arguments: state.socailRegisterParam);
          else if (widget.registerationType == RegisterationType.Enterprise) {
            Navigator.of(context).pushNamed(RegisterIndividualUserScreen.routeName,
                arguments: state.socailRegisterParam);
          } else {
            Navigator.of(context).pushNamed(RegisterBusinessUserScreen.routeName,
                arguments: state.socailRegisterParam);
          }
        }
      }
    } else {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(context).invalid_facebook_account, context);
    }
  }
}

//RegisterIndividualUserScreen
enum RegisterationType { NormalUser, Individual, Enterprise, Null }
