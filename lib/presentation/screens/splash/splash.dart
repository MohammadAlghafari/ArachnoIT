import 'package:arachnoit/application/latest_version/latest_version_bloc.dart';
import 'package:arachnoit/presentation/custom_widgets/restart_widget.dart';
import 'package:arachnoit/presentation/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  LatestVersionBloc latestVersionBloc;
  SplashScreen({@required this.latestVersionBloc});
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LatestVersionBloc>(
      create: (context) => widget.latestVersionBloc,
      child: BlocListener<LatestVersionBloc, LatestVersionState>(
        listener: (context, state) {
          if (state is GoingToMainScreen) {
            RestartWidget.of(context).restartApp();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Image.asset(
                      "assets/images/ic_launcher_app.png",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
import 'dart:async';
import 'package:arachnoit/application/latest_version/latest_version_bloc.dart';
import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/screens/main/main_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injections.dart';

class SplashScreen extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  var _visible = true;
  AnimationController animationController;
  Animation<double> animation;
  // startTime() async {
  //   var _duration = new Duration(seconds: 2);
  //   return new Timer(_duration, () {
  //     Navigator.of(context).pushAndRemoveUntil<void>(
  //       MaterialPageRoute<void>(builder: (BuildContext context) => MainScreen()),
  //       ModalRoute.withName('/'),
  //     );
  //   });
  // }

  LatestVersionBloc latestVersionBloc;
  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
       latestVersionBloc = serviceLocator<LatestVersionBloc>();
      if (!AppConst.CHECKED_VERSION_APP) {
        bool connectionState = await GlobalPurposeFunctions.isInternet();
        if (connectionState) {
          firstTime = false;
          latestVersionBloc.add(CheckVersion(context: context));
        } else {
          if (firstTime) {
            firstTime = false;
            Navigator.of(context).pushAndRemoveUntil<void>(
              MaterialPageRoute<void>(builder: (BuildContext context) => MainScreen()),
              ModalRoute.withName('/'),
            );
          }
        }
      } else {
        firstTime = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LatestVersionBloc>(
      create: (context) => latestVersionBloc..add(CheckVersion(context: context)),
      child: BlocListener<LatestVersionBloc, LatestVersionState>(
        listener: (context, state) {
          print("md;lsamd;lsamd;lams;dlwpe[i2-e2-=9e2=-e92e2");
          if (state is GoingToMainScreen) {
            Navigator.of(context).pushAndRemoveUntil<void>(
              MaterialPageRoute<void>(builder: (BuildContext context) => MainScreen()),
              ModalRoute.withName('/'),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Image.asset(
                      "assets/images/ic_launcher_app.png",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
