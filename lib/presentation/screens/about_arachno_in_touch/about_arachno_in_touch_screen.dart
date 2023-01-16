import 'dart:ui';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutArachnoInTouchScreen extends StatelessWidget {
  static const routeName = '/about_health_in_touch_screen';

  const AboutArachnoInTouchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: AppLocalizations.of(context).about_health_in_touch,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Arc(
                    arcType: ArcType.CONVEY,
                    edge: Edge.BOTTOM,
                    height: 50.0,
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Center(
                              child: Image(
                            image: AssetImage('assets/images/splash_logo.png'),
                            width: 300,
                            height: 100,
                            fit: BoxFit.contain,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'About',
                    style: semiBoldMontserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  left: 66,
                  right: 66,
                  top: 31,
                  child: Text(
                    "US",
                    style: italicReey(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    child: Container(
                      color: Colors.white,
                      width: 60,
                      height: 2,
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: AutoDirection(
                  text: AppLocalizations.of(context).about_health,
                  child: Text(
                    AppLocalizations.of(context).about_health,
                    textAlign: TextAlign.start,
                    style: regularMontserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            ),
            Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "OUR",
                    style: semiBoldMontserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  left: 50,
                  right: 50,
                  top: 31,
                  child: Text(
                    "Vision",
                    style: italicReey(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    child: Container(
                      color: Colors.white,
                      width: 45,
                      height: 2,
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: AutoDirection(
                  text: AppLocalizations.of(context).about_our_vision,
                  child: Text(
                    AppLocalizations.of(context).about_our_vision,
                    textAlign: TextAlign.start,
                    style: regularMontserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            ),
            Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "OUR",
                    style: semiBoldMontserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  left: 50,
                  right: 50,
                  top: 31,
                  child: Text(
                    "Mision",
                    style: italicReey(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    child: Container(
                      color: Colors.white,
                      width: 45,
                      height: 2,
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: AutoDirection(
                  text: AppLocalizations.of(context).about_our_mision,
                  child: Text(
                    AppLocalizations.of(context).about_our_mision,
                    textAlign: TextAlign.start,
                    style: regularMontserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            ),
            Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "OUR",
                    style: semiBoldMontserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  left: 50,
                  right: 50,
                  top: 31,
                  child: Text(
                    "Services",
                    style: italicReey(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    child: Container(
                      color: Colors.white,
                      width: 45,
                      height: 2,
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: AutoDirection(
                  text: AppLocalizations.of(context).about_our_services,
                  child: Text(
                    AppLocalizations.of(context).about_our_services,
                    textAlign: TextAlign.start,
                    style: regularMontserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )),
            ),
            Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Advantages',
                    // AppLocalizations.of(context).advantages,
                    style: semiBoldMontserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    child: Container(
                      color: Colors.white,
                      width: 45,
                      height: 2,
                    )),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: AutoDirection(
                  text: AppLocalizations.of(context).about_advantages,
                  child: Text(
                    AppLocalizations.of(context).about_advantages,
                    textAlign: TextAlign.start,
                    style: regularMontserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )),
            Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "OUR",
                    style: semiBoldMontserrat(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  left: 50,
                  right: 50,
                  top: 31,
                  child: Text(
                    "Clients",
                    style: italicReey(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    child: Container(
                      color: Colors.white,
                      width: 45,
                      height: 2,
                    )),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                child: AutoDirection(
                  text: AppLocalizations
                      .of(context)
                      .about_clients,
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .about_clients,
                    textAlign: TextAlign.start,
                    style: regularMontserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
