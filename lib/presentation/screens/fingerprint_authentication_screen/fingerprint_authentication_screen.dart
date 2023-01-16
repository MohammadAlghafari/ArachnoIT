import 'package:arachnoit/application/local_auth/local_auth_bloc.dart';
import 'package:arachnoit/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FingerprintAuthenticationScreen extends StatefulWidget {
  static const routeName = '/finger_print_authentication_screen';
  FingerprintAuthenticationScreen({Key key}) : super(key: key);

  @override
  _FingerprintAuthenticationScreenState createState() => _FingerprintAuthenticationScreenState();
}

class _FingerprintAuthenticationScreenState extends State<FingerprintAuthenticationScreen> {
  LocalAuthBloc localAuthBloc;
  @override
  void initState() {
    localAuthBloc = serviceLocator<LocalAuthBloc>()..add(AuthenticatEvent(context: context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(AppLocalizations.of(context).scan_your_fingerprint_to_get_access,textAlign: TextAlign.center ,style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),),
            ),
             Center(child: Image(image: AssetImage('assets/images/splash_logo.png'),width: 300, height: 100, fit: BoxFit.contain,)),
          ],
        ),
      ),
    );
  }
}