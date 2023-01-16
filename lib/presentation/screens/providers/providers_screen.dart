import 'package:arachnoit/application/providers_all/providers_all_bloc.dart';
import 'package:arachnoit/application/providers_favorite/providers_favorite_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

import '../../../application/providers/providers_bloc.dart';
import '../../../injections.dart';
import '../providers_all/providers_all_screen.dart';
import '../providers_favorite/providers_favorite_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProvidersScreen extends StatefulWidget {
  ProvidersScreen({Key key}) : super(key: key);

  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  ProvidersBloc providerBloc;
  ProvidersAllBloc providersAllBloc;
  ProvidersFavoriteBloc providersFavoriteBloc;
  @override
  void initState() {
    super.initState();
    providerBloc = serviceLocator<ProvidersBloc>();
    providersAllBloc = serviceLocator<ProvidersAllBloc>();
    providersFavoriteBloc = serviceLocator<ProvidersFavoriteBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Theme.of(context).accentColor,
                  indicatorColor: Theme.of(context).accentColor,
                  labelStyle: lightMontserrat(
                    color: Theme
                        .of(context)
                        .accentColor,
                    fontSize: 15,
                  ),
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context).all,
                    ),
                    Tab(
                      text: AppLocalizations.of(context).favourite,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(children: [
              Container(
                child: ProvidersAllScreen(),
              ),
              Container(
                child: ProvidersFavoriteScreen(),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
