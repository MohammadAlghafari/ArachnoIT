import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/screens/in_app_terms_and_conditions/in_app_terms_and_conditions_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndPolicyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
            text: '${AppLocalizations.of(context).i_agree_with_the} \t',
            style: semiBoldMontserrat(
              color: Colors.black,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                  text: '${AppLocalizations.of(context).terms}\t',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).accentColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InAppTermsAndConditionsScreen(
                                    isTermsRequest: true),
                          ));
                    }),
              TextSpan(
                text: " ${AppLocalizations
                    .of(context)
                    .of_use_and}" + "\n",
                style: semiBoldMontserrat(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                  text: ' ${AppLocalizations.of(context).privacy_policy}\t',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).accentColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InAppTermsAndConditionsScreen(
                                    isTermsRequest: false),
                          ));
                    }),
            ]),
      ),
    );
  }
}
