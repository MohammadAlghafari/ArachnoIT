part of 'main_bloc.dart';

@immutable
abstract class MainEvent {
  const MainEvent();
}

class MainTabUpdated extends MainEvent {
  final MainTab tab;

  const MainTabUpdated(this.tab);

  @override
  String toString() => 'TabUpdated { tab: $tab }';
}

class MainLoggedOutTabUpdated extends MainEvent {
  final MainTabUnLoggedIn loggedOutTab;

  const MainLoggedOutTabUpdated(this.loggedOutTab);

  @override
  String toString() => 'TabUpdated { tab: $loggedOutTab }';
}

class ChangeLoginStatus extends MainEvent {
  final bool currentValue;
  const ChangeLoginStatus(this.currentValue);
}

class ChangeImage extends MainEvent {
  final String image;
  ChangeImage({this.image});
}

class ChangeNumberOfUnReadNotiications extends MainEvent {
  final int unReadMessage;
  ChangeNumberOfUnReadNotiications({this.unReadMessage});
}

class IncreaseOrDicreaseNotification extends MainEvent {
  final int countOfIncrease;
  IncreaseOrDicreaseNotification({this.countOfIncrease});
}
