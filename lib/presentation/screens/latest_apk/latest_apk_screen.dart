import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_store/open_store.dart';

class LatestApkScreen extends StatefulWidget {
  static const routeName = '/latest_apk_screen';

  LatestApkScreen({
    Key key,
    @required this.isForceUpdate,
  }) : super(key: key);

  final isForceUpdate;

  @override
  _LatestApkScreenState createState() => _LatestApkScreenState();
}

class _LatestApkScreenState extends State<LatestApkScreen> {
  bool _isForceUpdate;

  @override
  void initState() {
    _isForceUpdate = widget.isForceUpdate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).size.height / 6),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                "assets/images/ic_update.svg",
                color: Theme.of(context).primaryColor,
                fit: BoxFit.cover,
                width: 125,
                height: 125,
                alignment: Alignment.center,
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.all(15.0),
              child: Text(
                "You are using an old version of the app please update your app to the latest version",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                onPressed: () {
                  OpenStore.instance.open(
                    appStoreId: '', // AppStore id of your app
                    androidAppBundleId:
                        'net.arachnoit.ait', // Android app bundle package name
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.circular(25)),
                ),
                color: Theme.of(context).accentColor,
                child: Text(
                  Platform.isIOS
                      ? "Update from app store"
                      : "Update from play store",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: !_isForceUpdate
                  ? FlatButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(25)),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
