import 'dart:ui';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/local_auth/local_auth_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../common/pref_keys.dart';
import '../../../injections.dart';
import '../../custom_widgets/needs_login_dialog.dart';
import '../change_password/change_password_screen.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings_screen';
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  LocalAuthBloc localAuthBloc;

  @override
  void initState() {
    localAuthBloc = serviceLocator<LocalAuthBloc>()
      ..add(CheckBiometricsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarProject.showAppBar(
          title: AppLocalizations.of(context).settings,
        ),
        body: BlocProvider(
          create: (context) => localAuthBloc,
          child: BlocListener<LocalAuthBloc, LocalAuthState>(
            listener: (context, state) {
              if (state.authenticationFinished)
                GlobalPurposeFunctions.showToast(
                    AppLocalizations.of(context).fingerprint_added, context);
            },
            child: BlocBuilder<LocalAuthBloc, LocalAuthState>(
                builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String loginResponse =
                            prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                        if (loginResponse != null)
                          Navigator.of(context)
                              .pushNamed(ChangePasswordScreen.routeName);
                        else
                          showDialog(
                              context: context,
                              builder: (context) => NeedsLoginDialog());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .change_your_password,
                                  style: boldCircular(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .change_your_currently_password_with_a_new_one,
                                  style: lightMontserrat(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                  if (state.hasBiometrics)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.fingerprint,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .enable_fingerprint_authentication,
                                  style: boldCircular(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .add_your_fingerprint_to_lock_the_app_with_it,
                                  style: lightMontserrat(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Switch(
                            value: state.authenticated,
                            onChanged: (value) {
                              !state.authenticated
                                  ? BlocProvider.of<LocalAuthBloc>(context)
                                      .add(AuthenticatEvent(context: context))
                                  : BlocProvider.of<LocalAuthBloc>(context)
                                      .add(UnAuthenticatEvent());
                            },
                            activeColor: Theme.of(context).accentColor,
                          )
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),
        ));
  }
}
