import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarProject {
  static Widget showAppBar({
    @required String title,
    bool centerTitle,
    List<Widget> actions,
    Widget leadingWidget,
    BuildContext context,
    PreferredSizeWidget bottomWidget,
    bool automaticallyImplyLeading = true,
  }) {
    return AppBar(
        bottom: bottomWidget,
        backgroundColor: Colors.white,
        centerTitle: centerTitle ?? false,
        actions: actions,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          title,
          style: boldCircular(
            color: Colors.black,
            fontSize: 18,
          ),
          // style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.light, // this makes status bar text color black
        leading: leadingWidget,
        automaticallyImplyLeading: automaticallyImplyLeading);
  }
}
