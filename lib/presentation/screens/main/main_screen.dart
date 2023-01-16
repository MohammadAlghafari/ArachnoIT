import 'dart:convert';

import 'package:arachnoit/application/notification_provider/notification_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/domain/common/check_user_login.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/needs_login_dialog.dart';
import 'package:arachnoit/presentation/screens/discover_categoreis/discover_categoreis_screen.dart';
import 'package:arachnoit/presentation/screens/discover_logged_out/dicover_logged_out_screen.dart';
import 'package:arachnoit/presentation/screens/home_blog/home_blog_screen.dart';
import 'package:arachnoit/presentation/screens/home_qaa/home_qaa_screen.dart';
import 'package:arachnoit/presentation/screens/in_app_terms_and_conditions/in_app_terms_and_conditions_Screen.dart';
import 'package:arachnoit/presentation/screens/notification/notification_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/profile_provider/profile_provider_screen.dart';
import 'package:arachnoit/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../application/main/main_bloc.dart';
import '../../../domain/main/local/Main_tabs.dart';
import '../../../injections.dart';
import '../../custom_widgets/main_drawer.dart';
import '../discover/discover_screen.dart';
import '../groups/groups_screen.dart';
import '../home/home_screen.dart';
import '../providers/providers_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ValueNotifier<String> stringImage;
  MainBloc mainBloc;

  @override
  void initState() {
    super.initState();
    mainBloc = BlocProvider.of(context);
    if (GlobalPurposeFunctions.getUserObject() != null) {
      print("GlobalPurposeFunctions.getUserObject() != null");
      NotificationBloc notificationBloc = serviceLocator<NotificationBloc>();
      notificationBloc
          .add(GetUserNotificationEvent(isRefreshData: false, reloadData: false, context: context));
    }
    getLoginResponse();
  }

  Image appLogo = new Image(
      image: new ExactAssetImage("assets/images/platform_icon.png"),
      height: 45.0,
      width: 45.0,
      alignment: FractionalOffset.centerLeft);

  Future<String> getLoginResponse() async {
    stringImage = ValueNotifier("");
    if (GlobalPurposeFunctions.getUserObject() == null) return null;
    String photoUrl = GlobalPurposeFunctions.getUserObject().photoUrl;
    stringImage.value = photoUrl;
    return photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => mainBloc,
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {},
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      bool isUserLogicn = await CheckUserLogin.getLoginStatus();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                    isLoginIn: isUserLogicn,
                                  )));
                    },
                  ),
                  if (GlobalPurposeFunctions.getUserObject() != null)
                    state.unReadNotificationCount == 0
                        ? IconButton(
                            icon: Icon(Icons.notifications_active),
                            onPressed: () async {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => NotificationScreen()));
                            },
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => NotificationScreen()));
                            },
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.notifications_active,
                                      size: 36,
                                    ),
                                    Transform.translate(
                                        offset: Offset(
                                            Localizations.localeOf(context).toString() == "ar"
                                                ? 6
                                                : 18,
                                            0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(120),
                                          child: Container(
                                            child: Center(
                                              child: Text(
                                              (state.unReadNotificationCount>100)?"+99":state.unReadNotificationCount.toString(),
                                                style: mediumMontserrat(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            width: 25,
                                            height: 25,
                                            color: Theme.of(context).accentColor,
                                          ),
                                        )
                                        // CircleAvatar(
                                        //   minRadius: 12,
                                        //   maxRadius: 12,
                                        //   backgroundColor: Theme.of(context).accentColor,
                                        //   child: Flexible(
                                        //     child: Text(
                                        //       state.unReadNotificationCount.toString(),
                                        //       style: TextStyle(color: Colors.white, fontSize: 14),
                                        //     ),
                                        //   ),
                                        // ),
                                        )
                                  ],
                                ),
                              ),
                            ),
                          ),
                  Padding(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: FutureBuilder(
                      future: getLoginResponse(),
                      builder: (context, snapData) {
                        if (snapData.data != null ||
                            snapData.data.toString().isNotEmpty && state.isUserLogin) {
                          return ChachedNetwrokImageView(
                              imageUrl: state.image,
                              isCircle: true,
                              width: 35,
                              showFullImageWhenClick: false,
                              height: 35,
                              function: () {
                                Navigator.of(context)
                                    .pushNamed(ProfileProviderScreen.routeName)
                                    .then((value) {
                                  mainBloc.add(ChangeImage(image: value));
                                });
                              });
                        } else
                          return IconButton(
                            icon: Icon(
                              Icons.person_rounded,
                            ),
                            onPressed: () async {
                              if (state.isUserLogin)
                                Navigator.of(context).pushNamed(ProfileProviderScreen.routeName);
                              else
                                showDialog(
                                  context: context,
                                  builder: (context) => NeedsLoginDialog(),
                                );
                            },
                          );
                      },
                    ),
                  ),
                ],
                elevation: 0.0,
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                  ),
                  child: appLogo,
                ),
              ),
              drawer: MainDrawer(mainBloc: mainBloc),
              body: (state.isUserLogin)
                  ? IndexedStack(
                      index: state.tab == MainTab.Home
                          ? 0
                          : state.tab == MainTab.Groups
                              ? 1
                              : state.tab == MainTab.Providers
                                  ? 2
                                  : state.tab == MainTab.Discover
                                      ? 3
                                      : 0,
                      children: screens,
                    )
                  : IndexedStack(
                      index: state.loggedOutTab == MainTabUnLoggedIn.Discover
                          ? 0
                          : state.loggedOutTab == MainTabUnLoggedIn.Blogs
                              ? 1
                              : state.loggedOutTab == MainTabUnLoggedIn.Questions
                                  ? 2
                                  : 0,
                      children: loggeOutScreens,
                    ),
              /*   PageStorage(
                bucket: bucket,
                child: state.tab == MainTab.Home
                    ? screens[0]
                    : state.tab == MainTab.Groups
                        ? screens[1]
                        : state.tab == MainTab.Providers
                            ? screens[2]
                            : state.tab == MainTab.Discover
                                ? screens[3]
                                : screens[0],
              ), */
              bottomNavigationBar: (state.isUserLogin)
                  ? TabSelector(
                      activeTab: state.tab,
                      onTabSelected: (tab) =>
                          BlocProvider.of<MainBloc>(context).add(MainTabUpdated(tab)),
                    )
                  : LoggedOutTabSelector(
                      activeTab: state.loggedOutTab,
                      onTabSelected: (tab) =>
                          BlocProvider.of<MainBloc>(context).add(MainLoggedOutTabUpdated(tab)),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class TabSelector extends StatelessWidget {
  final MainTab activeTab;
  final Function(MainTab) onTabSelected;

  TabSelector({
    @required this.activeTab,
    @required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: MainTab.values.indexOf(activeTab != null ? activeTab : MainTab.Home),
      onTap: (index) => onTabSelected(MainTab.values[index]),
      items: MainTab.values.map((tab) {
        return BottomNavigationBarItem(
            icon: Icon(tab == MainTab.Home
                ? Icons.home
                : tab == MainTab.Groups
                    ? Icons.group
                    : tab == MainTab.Providers
                        ? Icons.person
                        : Icons.explore),
            label: tab == MainTab.Home
                ? AppLocalizations.of(context).home
                : tab == MainTab.Groups
                    ? AppLocalizations.of(context).groups
                    : tab == MainTab.Providers
                        ? AppLocalizations.of(context).providers
                        : AppLocalizations.of(context).discover);
      }).toList(),
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).accentColor,
    );
  }
}

class LoggedOutTabSelector extends StatelessWidget {
  final MainTabUnLoggedIn activeTab;
  final Function(MainTabUnLoggedIn) onTabSelected;

  LoggedOutTabSelector({
    @required this.activeTab,
    @required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: MainTabUnLoggedIn.values
          .indexOf(activeTab != null ? activeTab : MainTabUnLoggedIn.Discover),
      onTap: (index) => onTabSelected(MainTabUnLoggedIn.values[index]),
      items: MainTabUnLoggedIn.values.map((tab) {
        return BottomNavigationBarItem(
            icon: Icon(tab == MainTabUnLoggedIn.Discover
                ? Icons.explore
                : tab == MainTabUnLoggedIn.Blogs
                    ? Icons.home
                    : Icons.question_answer),
            label: tab == MainTabUnLoggedIn.Discover
                ? AppLocalizations.of(context).discover
                : tab == MainTabUnLoggedIn.Blogs
                    ? AppLocalizations.of(context).blogs
                    : AppLocalizations.of(context).questionAndAnswer);
      }).toList(),
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).accentColor,
    );
  }
}

//final PageStorageBucket bucket = PageStorageBucket();
final List<Widget> screens = [
  HomeScreen(),
  GroupsScreen(),
  ProvidersScreen(),
  DiscoverScreen(),
];

final List<Widget> loggeOutScreens = [
  DiscoverCategoriesScreen(),
  HomeBlogScreen(shouldReloadData: false),
  HomeQaaScreen(shouldReloadData: false),
];
