import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MyInterestsItem extends StatelessWidget {
   final String title;
   final int counte;
   final bool isSubscribedTo;
   final Function function;
  const MyInterestsItem({Key key,this.title,this.counte,this.isSubscribedTo,this.function}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0.0,
        margin: EdgeInsets.only(bottom: 3),
              child: ListTile(
              onTap:function,
              title: Text(
                title,
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "$counte\t${AppLocalizations.of(context).activity_on_this_sub_category}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              trailing: Icon(
                (isSubscribedTo)?
                Icons.notifications_active:Icons.notifications_on_outlined,color: Theme.of(context).primaryColor),
            ),
      ),
    );
  }
}