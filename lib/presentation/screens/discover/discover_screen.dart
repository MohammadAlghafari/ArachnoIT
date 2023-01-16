import 'package:arachnoit/presentation/screens/discover_my_interests_add_interests/discover_my_interests_add_interests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/discover/discover_bloc.dart';
import '../../../injections.dart';
import '../discover_categoreis/discover_categoreis_screen.dart';
import '../discover_my_intresets/discover_my_intresets_screen.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({Key key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  DiscoverBloc discoverBloc;

  @override
  void initState() {
    super.initState();
    discoverBloc = serviceLocator<DiscoverBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: DiscoverMyInterestsAddInterestsScreen(),
      ),
    );
  }
}
