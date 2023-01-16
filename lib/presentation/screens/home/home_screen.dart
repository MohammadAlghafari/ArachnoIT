import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/recreate_widget.dart';
import 'package:arachnoit/presentation/screens/search_group/search_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/home_bloc.dart';
import '../../../injections.dart';
import '../home_blog/home_blog_screen.dart';
import '../home_qaa/home_qaa_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = serviceLocator<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<HomeBloc>(
        create: (context) => homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (current, state) =>
          (current.shouldRebuildHomeQAA != state.shouldRebuildHomeQAA) ||
              (current.shouldRebuildHomeBlogs != state.shouldRebuildHomeBlogs),
          builder: (context, state) {
            return DefaultTabController(
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
                        labelStyle: boldCircular(
                          color: Theme
                              .of(context)
                              .accentColor,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(
                            text: AppLocalizations.of(context).blogs,
                          ),
                          Tab(
                            text:
                            AppLocalizations
                                .of(context)
                                .questionAndAnswer,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(children: [
                        RecreateWidget(
                          shouldRecreate: state.shouldRebuildHomeBlogs,
                          child: HomeBlogScreen(
                              shouldReloadData: state.shouldRebuildHomeBlogs),
                        ),
                        RecreateWidget(
                          shouldRecreate: state.shouldRebuildHomeQAA,
                          child: HomeQaaScreen(
                              shouldReloadData: state.shouldRebuildHomeQAA),
                        ),
                      ]))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
