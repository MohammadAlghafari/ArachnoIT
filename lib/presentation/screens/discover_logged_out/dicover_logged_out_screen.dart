import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/discover/discover_bloc.dart';
import '../../../injections.dart';
import '../discover_categoreis/discover_categoreis_screen.dart';

class DiscoverLoogedOutScreen extends StatefulWidget {
  DiscoverLoogedOutScreen({Key key}) : super(key: key);

  @override
  _DiscoverLoogedOutScreen createState() => _DiscoverLoogedOutScreen();
}

class _DiscoverLoogedOutScreen extends State<DiscoverLoogedOutScreen> {
  DiscoverBloc discoverBloc;

  @override
  void initState() {
    super.initState();
    discoverBloc = serviceLocator<DiscoverBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      text:AppLocalizations.of(context).categories,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(children: [
              Container(
                child: DiscoverCategoriesScreen(),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
