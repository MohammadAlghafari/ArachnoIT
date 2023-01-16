import 'dart:io';
import 'package:arachnoit/application/main/main_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/domain/main/local/Main_tabs.dart';
import 'package:arachnoit/presentation/screens/active_session/active_session.dart';
import 'package:arachnoit/presentation/screens/discover_my_intresets/discover_my_intresets_screen.dart';
import 'package:arachnoit/presentation/screens/pending_list/pending_list_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/profile_provider/profile_provider_screen.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import '../../application/language/language_bloc.dart';
import '../../application/logout/logout_bloc.dart';
import '../../common/global_prupose_functions.dart';
import '../../common/pref_keys.dart';
import '../../injections.dart';
import '../screens/about_arachno_in_touch/about_arachno_in_touch_screen.dart';
import '../screens/change_password/change_password_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/registraition/registration_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/userManual/user_manual_screen.dart';
import 'language_bottom_sheet.dart';
import 'needs_login_dialog.dart';
import 'restart_widget.dart';

class MainDrawer extends StatefulWidget {
  final MainBloc mainBloc;
  MainDrawer({@required this.mainBloc});
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Map<String, dynamic> deviceData = <String, dynamic>{};
  LanguageBloc languageBloc;
  LogoutBloc logoutBloc;
  SharedPreferences _prefs;
  String _loginResponse;
  AndroidDeviceInfo mobileInfo;
  String wifiIP = "";
  @override
  void initState() {
    super.initState();
    languageBloc = serviceLocator<LanguageBloc>();
    logoutBloc = serviceLocator<LogoutBloc>();
    _prefs = serviceLocator<SharedPreferences>();
    _loginResponse = _prefs.getString(PrefsKeys.LOGIN_RESPONSE);
  }

  Widget buildListTile(String title, IconData icon, BuildContext context, Function tapHandler) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      onTap: tapHandler,
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: lightMontserrat(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget buildListTileHeader(String title) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          style: lightMontserrat(
            color: Colors.black54,
            fontSize: 14,
          ),
        ));
  }

  Widget buildDivider() {
    return Divider(
      thickness: 0.2,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 175,
                width: double.infinity,
                padding: EdgeInsets.all(40),
                alignment: Alignment.center,
                color: Theme.of(context).primaryColor,
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).arachno,
                      style: mediumMontserrat(fontSize: 30, color: Colors.grey[200]),
                    ),
                    Text(
                      AppLocalizations.of(context).it,
                      style: mediumMontserrat(fontSize: 30, color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              buildListTileHeader(AppLocalizations.of(context).general),
              buildListTile(AppLocalizations.of(context).profile, Icons.person_outline, context,
                  () {
                if (_loginResponse != null) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(ProfileProviderScreen.routeName).then((value) {
                    widget.mainBloc.add(ChangeImage(image: value));
                  });
                } else
                  showDialog(
                    context: context,
                    builder: (context) => NeedsLoginDialog(),
                  );
              }),
              buildDivider(),
              buildListTileHeader(
                AppLocalizations.of(context).platform,
              ),
              (GlobalPurposeFunctions.getUserObject() == null)
                  ? showNavigationWhenUserLogout()
                  : showNavigationWhenUserLogin(),
              buildDivider(),
              buildListTileHeader(
                AppLocalizations.of(context).settings,
              ),
              buildListTile(
                  AppLocalizations.of(context).pending_list, Icons.pending_actions, context, () {
                if (_loginResponse != null) {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => PendingListSceen()));
                } else
                  showDialog(
                    context: context,
                    builder: (context) => NeedsLoginDialog(),
                  );
              }),
              buildListTile(AppLocalizations.of(context).language, Icons.language, context, () {
                Navigator.of(context).pop();
                showModalBottomSheet<dynamic>(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext bc) {
                      return LanguageBottomSheet(languageBloc: languageBloc);
                    });
              }),
              buildListTile(AppLocalizations.of(context).change_your_password, Icons.lock, context,
                  () {
                if (_loginResponse != null) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
                } else
                  showDialog(
                    context: context,
                    builder: (context) => NeedsLoginDialog(),
                  );
              }),
              buildListTile(AppLocalizations.of(context).settings, Icons.settings, context, () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SettingsPage.routeName);
              }),
              buildListTile(AppLocalizations.of(context).active_sessions, Icons.security, context,
                  () async {
                if (_loginResponse != null) {
                  mobileInfo = await GlobalPurposeFunctions.initPlatformState();
                  wifiIP = await GlobalPurposeFunctions.getIpAddress();
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActiveSession(
                            mobileInfo: mobileInfo,
                            wifiIP: wifiIP,
                          )));
                } else
                  showDialog(
                    context: context,
                    builder: (context) => NeedsLoginDialog(),
                  );
              }),
              buildListTile(AppLocalizations.of(context).my_interests, Icons.push_pin, context, () {
                if (_loginResponse != null) {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscoverMyIntresetsScreen(
                                showAppBar: true,
                              )));
                } else
                  showDialog(
                    context: context,
                    builder: (context) => NeedsLoginDialog(),
                  );
              }),
              buildDivider(),
              buildListTileHeader(
                AppLocalizations.of(context).other,
              ),
              buildListTile(AppLocalizations.of(context).invite_friend, Icons.share, context, () {
                Navigator.of(context).pop();
              }),
              buildListTile(
                  AppLocalizations.of(context).about_health_in_touch, Icons.fingerprint, context,
                  () {
                //2251835
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AboutArachnoInTouchScreen.routeName);
              }),
              buildListTile(AppLocalizations.of(context).user_manual, Icons.book, context, () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(UserManualScreen.routeName);
              }),
              if (_loginResponse != null)
                BlocProvider(
                  create: (context) => logoutBloc,
                  child: BlocListener<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      if (state is LoadingLogoutState)
                        GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
                      else if (state is UserLoggedoutState)
                        GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                            .then((value) => RestartWidget.of(context).restartApp());
                      else if (state is RemoteLogoutValidationErrorState) {
                        GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                            .then((value) => GlobalPurposeFunctions.showToast(
                                  state.remoteValidationErrorMessage,
                                  context,
                                ));
                      } else if (state is RemoteLogoutServerErrorState) {
                        GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                            .then((value) => GlobalPurposeFunctions.showToast(
                                  state.remoteServerErrorMessage,
                                  context,
                                ));
                      } else if (state is RemoteLogoutClientErrorState) {
                        GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                            .then((value) => GlobalPurposeFunctions.showToast(
                                  AppLocalizations.of(context).data_error,
                                  context,
                                ));
                      }
                    },
                    child: BlocBuilder<LogoutBloc, LogoutState>(builder: (context, state) {
                      return buildListTile(
                          AppLocalizations.of(context).logout, Icons.logout, context, () {
                        BlocProvider.of<LogoutBloc>(context).add(LogoutUserEvent());
                      });
                    }),
                  ),
                ),
              if (_loginResponse == null)
                buildListTile(AppLocalizations.of(context).login, Icons.login, context, () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                }),
              buildListTile(AppLocalizations.of(context).sign_up, Icons.person_add, context, () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(RegistrationScreen.routeName);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget showNavigationWhenUserLogout() {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: [
        buildListTile(AppLocalizations.of(context).blogs, Icons.bookmark_border, context, () {
          widget.mainBloc.add(MainLoggedOutTabUpdated(MainTabUnLoggedIn.Blogs));
          Navigator.of(context).pop();
        }),
        buildListTile(
            AppLocalizations.of(context).questionAndAnswer, Icons.question_answer, context, () {
          widget.mainBloc.add(MainLoggedOutTabUpdated(MainTabUnLoggedIn.Questions));
          Navigator.of(context).pop();
        }),
        buildListTile(AppLocalizations.of(context).favourite, Icons.star, context, () {
          widget.mainBloc.add(MainTabUpdated(MainTab.Discover));
          Navigator.of(context).pop();
        }),
      ],
    );
  }

  Widget showNavigationWhenUserLogin() {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: [
        buildListTile(AppLocalizations.of(context).home, Icons.bookmark_border, context, () {
          if (_loginResponse != null) {
            widget.mainBloc.add(MainTabUpdated(MainTab.Home));
            Navigator.of(context).pop();
          } else
            showDialog(
              context: context,
              builder: (context) => NeedsLoginDialog(),
            );
        }),
        if (_loginResponse != null)
          buildListTile(AppLocalizations.of(context).groups, Icons.group, context, () {
            widget.mainBloc.add(MainTabUpdated(MainTab.Groups));

            Navigator.of(context).pop();
          }),
        buildListTile(AppLocalizations.of(context).search, Icons.search, context, () {
          widget.mainBloc.add(MainTabUpdated(MainTab.Providers));
          Navigator.of(context).pop();
        }),
        if (_loginResponse != null)
          buildListTile(AppLocalizations.of(context).favourite, Icons.star, context, () {
            widget.mainBloc.add(MainTabUpdated(MainTab.Discover));
            Navigator.of(context).pop();
          }),
        if (_loginResponse != null)
          buildListTile(AppLocalizations.of(context).chat, Icons.message_outlined, context, () {
            Navigator.of(context).pop();
          }),
      ],
    );
  }
}
