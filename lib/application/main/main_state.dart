part of 'main_bloc.dart';

@immutable
// ignore: must_be_immutable
class MainState {
  MainState(
      {this.tab,
      this.isUserLogin = false,
      this.loggedOutTab,
      this.image,
      this.unReadNotificationCount = 0}) {
    _initValue();
  }

  bool isUserLogin;
  String image;
  final MainTab tab;
  final MainTabUnLoggedIn loggedOutTab;
  int unReadNotificationCount;

  void _initValue() async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    if (sharedPreferences.get(PrefsKeys.UN_READ_MESSAGE) == null) {
      unReadNotificationCount = 0;
    } else {
      unReadNotificationCount = sharedPreferences.get(PrefsKeys.UN_READ_MESSAGE);
    }

    if (GlobalPurposeFunctions.getUserObject() == null)
      image = "";
    else {
      String photoUrl = GlobalPurposeFunctions?.getUserObject()?.photoUrl ?? "";
      image = photoUrl;
    }
    bool isUserLogicn = CheckUserLogin.getLoginStatus();
    this.isUserLogin = isUserLogicn;
  }

  MainState copyWith(
      {MainTab tab,
      MainTabUnLoggedIn loggedOutTab,
      String image,
      bool isUserLogin,
      int unReadNotificationCount}) {
    return MainState(
        isUserLogin: (isUserLogin) ?? this.isUserLogin,
        loggedOutTab: (loggedOutTab) ?? this.loggedOutTab,
        tab: (tab) ?? this.tab,
        image: image ?? this.image,
        unReadNotificationCount: unReadNotificationCount ?? this.unReadNotificationCount);
  }
}
