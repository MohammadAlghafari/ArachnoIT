import 'dart:ui';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/discover_categories_details/discover_categories_details_screen.dart';
import 'package:flutter/material.dart';

class DiscoverCategoryItem extends StatelessWidget {
  final Function function;
  final bool showTrueCheck;
  DiscoverCategoryItem({Key key,
    @required this.category,
    this.function,
    this.showTrueCheck = false})
      : super(key: key);

  final CategoryResponse category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              ChachedNetwrokImageView(
                  imageUrl: category.categoryImageUrl,
                  autoWidthAndHeigh: true,
                  function: function ??
                      () {
                        Navigator.of(context).pushNamed(
                            DiscoverCategriesDetailsScreen.routeName,
                            arguments: category);
                      }),
              InkWell(
                onTap: function ??
                    () {
                      Navigator.of(context).pushNamed(
                          DiscoverCategriesDetailsScreen.routeName,
                          arguments: category);
                    },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.25),
                    child: Center(
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: regularMontserrat(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              if (showTrueCheck)
                Align(
                  alignment: Localizations.localeOf(context).toString() == "ar"
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/check_true.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1,
          margin: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
