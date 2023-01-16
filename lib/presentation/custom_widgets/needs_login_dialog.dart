import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/login/login_screen.dart';

class NeedsLoginDialog extends StatelessWidget {
  const NeedsLoginDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Image(
            image: ExactAssetImage("assets/images/activation_dialog_logo.png"),
            height: 100.0,
            width: 100.0,
            alignment: FractionalOffset.center),
      ),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: '${AppLocalizations.of(context).please}\t',
            style: semiBoldMontserrat(
              color: Colors.black,
              fontSize: 16,
            ),
            children: [
              TextSpan(
                  text: '${AppLocalizations.of(context).login}\t',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).accentColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    }),
              TextSpan(
                text: AppLocalizations
                    .of(context)
                    .to_your_account,
                style: semiBoldMontserrat(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ]),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context).cancel,
              style: mediumMontserrat(
                color: Theme
                    .of(context)
                    .accentColor,
                fontSize: 14,
              ),
            ))
      ],
    );
  }
}
