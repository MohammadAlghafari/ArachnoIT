import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/injections.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckUserLogin {
  static bool getLoginStatus()  {
  SharedPreferences  prefs=serviceLocator<SharedPreferences>();
    var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
    if (loginResponse != null) {
      return true;
    } else {
      return false;
    }
  }
}
