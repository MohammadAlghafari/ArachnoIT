import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';

import '../../../application/discover_my_interests_sub_catergories_details/discover_my_interests_sub_catergories_details_bloc.dart';
import '../../../infrastructure/common_response/sub_category_response.dart';
import '../discover_my_interests_sub_categories_blogs/discover_my_interests_sub_categories_blogs_screen.dart';
import '../discover_my_interests_sub_categories_qaa/discover_my_interest_sub_categories_qaa_screen.dart';
import 'package:flutter/material.dart';
import '../../../injections.dart';
import '../home_qaa/home_qaa_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscoverMyInterestsSubCategoriesDetailsScreen extends StatefulWidget {
  final SubCategoryResponse subCategoryItem;

  const DiscoverMyInterestsSubCategoriesDetailsScreen(
      {Key key, this.subCategoryItem})
      : super(key: key);
  @override
  _DiscoverMyInterestsSubCategoriesDetailsScreen createState() =>
      _DiscoverMyInterestsSubCategoriesDetailsScreen();
}

class _DiscoverMyInterestsSubCategoriesDetailsScreen
    extends State<DiscoverMyInterestsSubCategoriesDetailsScreen> {
  DiscoverMyInterestsSubCatergoriesDetailsBloc
      discoverMyInterestsSubCatergoriesDetailsBloc;

  @override
  void initState() {
    super.initState();
    discoverMyInterestsSubCatergoriesDetailsBloc =
        serviceLocator<DiscoverMyInterestsSubCatergoriesDetailsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: widget.subCategoryItem.name ?? "",
      ),
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
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      text:AppLocalizations.of(context).blogs,
                    ),
                    Tab(
                      text:AppLocalizations.of(context).questionAndAnswer,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(children: [
              Container(
                child: DiscoverMyInterestsSubCategoriesBlogsScreen(
                  subCategoryInfo: widget.subCategoryItem,
                ),
              ),
              Container(
                child: DisocverMyInterestSubCategorisQaaScreen(
                  subCategoryInfo: widget.subCategoryItem,
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
