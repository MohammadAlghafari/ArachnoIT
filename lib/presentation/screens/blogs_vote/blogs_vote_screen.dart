import 'package:arachnoit/application/blogs_useful_vote/blogs_useful_vote_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/screens/blogs_emphases/blogs_emphases_screen.dart';
import 'package:arachnoit/presentation/screens/blogs_useful_vote/blogs_useful_vote_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../discover_categoreis/discover_categoreis_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlogsVoteScreen extends StatefulWidget {
  final String itemID;
  BlogsVoteScreen({@required this.itemID});
  @override
  _BlogsVoteScreen createState() => _BlogsVoteScreen();
}

class _BlogsVoteScreen extends State<BlogsVoteScreen> {
  BlogsUsefulVoteBloc blogsVoteBloc;
  @override
  void initState() {
    super.initState();
    blogsVoteBloc = serviceLocator<BlogsUsefulVoteBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
          title: AppLocalizations
              .of(context)
              .vote_people),
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
                  labelStyle: semiBoldMontserrat(
                    color: Theme
                        .of(context)
                        .accentColor,
                    fontSize: 14,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context).useful),
                          SizedBox(width: 10),
                          SvgPicture.asset(
                            "assets/images/ic_useful_clicked.svg",
                            color: Theme.of(context).accentColor,
                            fit: BoxFit.cover,
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context).emphasis),
                          SizedBox(width: 10),
                          SvgPicture.asset(
                            "assets/images/fill_favorite.svg",
                            color: Theme.of(context).accentColor,
                            fit: BoxFit.cover,
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(children: [
              Container(
                child: BlogsUsefulVoteScreen(
                  itemId: widget.itemID,
                ),
              ),
              Container(
                child: BlogsEmphasesVoteScreen(
                  itemId: widget.itemID,
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
