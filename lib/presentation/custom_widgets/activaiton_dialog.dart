import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/verification/verification_screen.dart';

class ActivationDialog extends StatelessWidget {
  const ActivationDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleDialog(
        title: Center(
          child: Image(
              image:
                  ExactAssetImage("assets/images/activation_dialog_logo.png"),
              height: 130.0,
              width: 130.0,
              alignment: FractionalOffset.center),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        children: [
          Center(
              child: Text(
            AppLocalizations.of(context).please_verify,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(VerificationScreen.routeName);
            },
            child: Center(
                child: Text(
              AppLocalizations.of(context).activate_your_account,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 15,
              ),
            )),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
