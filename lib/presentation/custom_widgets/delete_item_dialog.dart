import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/login/login_screen.dart';

class DeleteItemDialog extends StatelessWidget {
  final Function deleteFunction;

  const DeleteItemDialog({Key key, this.deleteFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Image(
            image: ExactAssetImage("assets/images/activation_dialog_logo.png"),
            height: 80.0,
            width: 100.0,
            alignment: FractionalOffset.center),
      ),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: AppLocalizations.of(context).do_you_need_delete_item,
          style: semiBoldMontserrat(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context).cancel,
              style: mediumMontserrat(
                color: Theme
                    .of(context)
                    .primaryColor,
                fontSize: 14,
              ),
            )),
        TextButton(
            onPressed: deleteFunction,
            child: Text(
              AppLocalizations.of(context).delete,
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
