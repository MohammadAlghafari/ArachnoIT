import 'package:arachnoit/application/discover_my_interests_add_interests/discover_my_interests_add_interests_bloc.dart';
import 'package:arachnoit/application/home/home_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/discover_categories_details/discover_categories_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../infrastructure/common_response/category_response.dart';
import 'discover_my_interests_add_sub_category_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscoverMyInterestsAddInterestsItem extends StatefulWidget {
  List<CategoryResponse> categoryResponse = [];
  final CategoryResponse categoryItem;
  final int index;
  final DiscoverMyInterestsAddInterestsBloc discoverMyInterestsAtInterestsBloc;
  DiscoverMyInterestsAddInterestsItem({
    @required this.categoryItem,
    @required this.index,
    @required this.discoverMyInterestsAtInterestsBloc,
    @required this.categoryResponse,
  });

  @override
  State<StatefulWidget> createState() {
    return _DiscoverMyInterestsAddInterestsItem();
  }
}

class _DiscoverMyInterestsAddInterestsItem
    extends State<DiscoverMyInterestsAddInterestsItem> {
  List<SubCategoryResponse> newSubCategoriesItem = [];
  Map<String, int> subCategoriesIndex = Map<String, int>();
  DiscoverMyInterestsAddInterestsBloc discoverMyInterestsAddInterestsBloc;
  HomeBloc homeBloc;
  @override
  void initState() {
    super.initState();
    discoverMyInterestsAddInterestsBloc =
        serviceLocator<DiscoverMyInterestsAddInterestsBloc>();
    homeBloc = serviceLocator<HomeBloc>();

    /// This To Get The SubCategories Index by Id
    /// Beacuse Wrap Can't Return Index For Select Item
    for (int i = 0; i < widget.categoryItem.subCategories.length; i++) {
      subCategoriesIndex[widget.categoryItem.subCategories[i].id] = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverMyInterestsAddInterestsBloc>.value(
      value: discoverMyInterestsAddInterestsBloc,
      child: BlocListener<DiscoverMyInterestsAddInterestsBloc,
          DiscoverMyInterestsAddInterestsState>(
        listener: (context, state) {},
        child: BlocBuilder<DiscoverMyInterestsAddInterestsBloc,
            DiscoverMyInterestsAddInterestsState>(
          builder: (context, state) {
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
                          imageUrl: widget.categoryItem.categoryImageUrl,
                          autoWidthAndHeigh: true,
                          function: () {
                            Navigator.of(context).pushNamed(
                                DiscoverCategriesDetailsScreen.routeName,
                                arguments: widget.categoryItem);
                            // _showSelectInterestBottomSheet(context);
                          }),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              DiscoverCategriesDetailsScreen.routeName,
                              arguments: widget.categoryItem);
                          // _showSelectInterestBottomSheet(context);
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black.withOpacity(0.4),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.categoryItem.name,
                                        textAlign: TextAlign.center,
                                        style: semiBoldMontserrat(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        onPressed: () {
                                          _showSelectInterestBottomSheet(
                                              context);
                                        },
                                        icon: Icon(
                                          (widget.categoryItem.isSubscribedTo)
                                              ? Icons.notifications_on_rounded
                                              : Icons.notifications_outlined,
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
          },
        ),
      ),
    );
  }

  List<SubCategoryResponse> addItemToNewSubCategoriesList() {
    List<SubCategoryResponse> item = [];
    for (int i = 0; i < widget.categoryItem.subCategories.length; i++) {
      SubCategoryResponse subCategoryResponse = new SubCategoryResponse(
        blogsCount: widget.categoryItem.subCategories[i].blogsCount,
        groupsCount: widget.categoryItem.subCategories[i].groupsCount,
        id: widget.categoryItem.subCategories[i].id,
        isSubscribedTo: widget.categoryItem.subCategories[i].isSubscribedTo,
        isValid: widget.categoryItem.subCategories[i].isValid,
        name: widget.categoryItem.subCategories[i].name,
        questionsCount: widget.categoryItem.subCategories[i].questionsCount,
      );
      item.add(subCategoryResponse);
    }
    return item;
  }

  _showSelectInterestBottomSheet(BuildContext context) {
    newSubCategoriesItem = addItemToNewSubCategoriesList();
    return showSlidingBottomSheet<dynamic>(
      context,
      builder: (context) {
        CategoryResponse categoryResponse = CategoryResponse(
            blogsCount: widget.categoryItem.blogsCount,
            categoryImageUrl: widget.categoryItem.categoryImageUrl,
            groupsCount: widget.categoryItem.groupsCount,
            id: widget.categoryItem.id,
            isSubscribedTo: widget.categoryItem.isSubscribedTo,
            isValid: widget.categoryItem.isValid,
            name: widget.categoryItem.name,
            questionsCount: widget.categoryItem.questionsCount,
            subCategories: widget.categoryItem.subCategories);

        return SlidingSheetDialog(
          color: Colors.grey.shade50,
          padding: EdgeInsets.only(top: 18),
          elevation: 8,
          cornerRadius: 16,
          extendBody: false,
          dismissOnBackdropTap: true,
          footerBuilder: (context, state) {
            return Container(
              height: 50,
              child: saveButton(context),
            );
          },
          listener: (state) {
            if (state.isHidden) {
              widget.categoryItem.subCategories = newSubCategoriesItem;
              discoverMyInterestsAddInterestsBloc.add(
                  UpdateSubCategoryStateFromBottomSheet(
                      index: widget.index, items: widget.categoryItem));
            }
          },
          duration: Duration(milliseconds: 60),
          builder: (context, state) {
            return BlocProvider.value(
              value: discoverMyInterestsAddInterestsBloc,
              child: BlocListener<DiscoverMyInterestsAddInterestsBloc,
                  DiscoverMyInterestsAddInterestsState>(
                listener: (context, state) {
                  if (state is ChangeCategoryStateByClickItem) {
                    categoryResponse = state.categoryResponse;
                  }
                },
                child: BlocBuilder<DiscoverMyInterestsAddInterestsBloc,
                    DiscoverMyInterestsAddInterestsState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Container(
                          child: Center(
                            child: Material(
                              child: ListView(
                                padding: EdgeInsets.all(22),
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  showBottomNavigationTitle(),
                                  SizedBox(height: 6),
                                  Text(
                                    AppLocalizations.of(context)
                                        .we_will_show_you_more_activity_from_the_sub_category_you_pick,
                                    style: mediumMontserrat(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: showListOfItem(
                                        context, categoryResponse),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // saveButton(context, -10),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: 2,
                            decoration: new BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                new BorderRadius.all(Radius.circular(7))),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget saveButton(BuildContext context) {
    return BlocProvider<DiscoverMyInterestsAddInterestsBloc>.value(
      value: widget.discoverMyInterestsAtInterestsBloc,
      child: BlocListener<DiscoverMyInterestsAddInterestsBloc,
          DiscoverMyInterestsAddInterestsState>(
        listener: (context, state) {
          if (state is SuccessSendActionSubscrption) {
            homeBloc.add(ChangeDestroyQAAStatus(destoryStatus: true));
            homeBloc.add(ChangeDestroyBlogsStatus(destoryStatus: true));
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) {
              Navigator.pop(context);
            });
            GlobalPurposeFunctions.showToast(state.message, context);
            newSubCategoriesItem = addItemToNewSubCategoriesList();
          }
        },
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            widget.discoverMyInterestsAtInterestsBloc.add(SendActionSubscrption(
                categoryResponse: widget.categoryResponse));
          },
          height: 50,
          child: Center(
            child: Text(
              AppLocalizations.of(context).save,
              style: boldMontserrat(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          color: Colors.black,
        ),
      ),
    );
  }

  Widget showListOfItem(BuildContext context,
      CategoryResponse categoryResponse) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: categoryResponse.subCategories.map((item) {
        return InkWell(
          onTap: () {
            BlocProvider.of<DiscoverMyInterestsAddInterestsBloc>(context).add(
                ChangeMyInterestClickEvent(
                    categoryResponse: categoryResponse,
                    index: subCategoriesIndex[item.id]));
          },
          child: DiscoverMyInterestsAddSubCategoryItem(
            selected: item.isSubscribedTo,
            subCategory: item,
          ),
        );
      }).toList(),
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      verticalDirection: VerticalDirection.down,
    );
  }

  Widget showBottomNavigationTitle() {
    return Text(
      widget.categoryItem.name,
      style: boldMontserrat(color: Colors.black, fontSize: 24),
    );
  }
}

/*
import 'package:arachnoit/application/discover_my_interests_add_interests/discover_my_interests_add_interests_bloc.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../infrastructure/common_response/category_response.dart';
import 'discover_my_interests_add_sub_category_item.dart';import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DiscoverMyInterestsAddInterestsItem extends StatefulWidget {
  final CategoryResponse categoryItem;
  final int index;
  DiscoverMyInterestsAddInterestsItem(
      {@required this.categoryItem, @required this.index});

  @override
  State<StatefulWidget> createState() {
    return _DiscoverMyInterestsAddInterestsItem();
  }
}

class _DiscoverMyInterestsAddInterestsItem
    extends State<DiscoverMyInterestsAddInterestsItem> {
  List<SubCategoryResponse> newSubCategoriesItem = [];
  Map<String, int> subCategoriesIndex = Map<String, int>();
  DiscoverMyInterestsAddInterestsBloc discoverMyInterestsAddInterestsBloc;
  @override
  void initState() {
    super.initState();
    discoverMyInterestsAddInterestsBloc =
        serviceLocator<DiscoverMyInterestsAddInterestsBloc>();

    /// This To Get The SubCategories Index by Id
    /// Beacuse Wrap Can't Return Index For Select Item

    for (int i = 0; i < widget.categoryItem.subCategories.length; i++) {
      subCategoriesIndex[widget.categoryItem.subCategories[i].id] = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscoverMyInterestsAddInterestsBloc>.value(
      value: discoverMyInterestsAddInterestsBloc,
      child: BlocListener<DiscoverMyInterestsAddInterestsBloc,
          DiscoverMyInterestsAddInterestsState>(
        listener: (context, state) {},
        child: BlocBuilder<DiscoverMyInterestsAddInterestsBloc,
            DiscoverMyInterestsAddInterestsState>(
          builder: (context, state) {
            return Container(
              child: Card(
                elevation: 0.0,
                margin: EdgeInsets.only(bottom: 3),
                child: ListTile(
                  onTap: () {
                    _showSelectInterestBottomSheet(context);
                  },
                  title: Text(
                    widget.categoryItem.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${widget.categoryItem.blogsCount + widget.categoryItem.groupsCount + widget.categoryItem.questionsCount}\t${AppLocalizations.of(context).activity_on_this_sub_category}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      (widget.categoryItem.isSubscribedTo)
                          ? Icons.notifications_active
                          : Icons.notifications_on_outlined,
                    ),
                    onPressed: () {
                      discoverMyInterestsAddInterestsBloc.add(
                          UpdateSubCategoryStateFromNotificationIcon(
                              index: widget.index,
                              items: widget.categoryItem,
                              subScripeAll:!widget.categoryItem.isSubscribedTo));
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<SubCategoryResponse> addItemToNewSubCategoriesList() {
    List<SubCategoryResponse> item = [];
    for (int i = 0; i < widget.categoryItem.subCategories.length; i++) {
      SubCategoryResponse subCategoryResponse = new SubCategoryResponse(
        blogsCount: widget.categoryItem.subCategories[i].blogsCount,
        groupsCount: widget.categoryItem.subCategories[i].groupsCount,
        id: widget.categoryItem.subCategories[i].id,
        isSubscribedTo: widget.categoryItem.subCategories[i].isSubscribedTo,
        isValid: widget.categoryItem.subCategories[i].isValid,
        name: widget.categoryItem.subCategories[i].name,
        questionsCount: widget.categoryItem.subCategories[i].questionsCount,
      );
      item.add(subCategoryResponse);
    }
    return item;
  }

  _showSelectInterestBottomSheet(BuildContext context) {
    newSubCategoriesItem = addItemToNewSubCategoriesList();
    return showSlidingBottomSheet<dynamic>(
      context,
      builder: (context) {
        CategoryResponse categoryResponse = CategoryResponse(
            blogsCount: widget.categoryItem.blogsCount,
            categoryImageUrl: widget.categoryItem.categoryImageUrl,
            groupsCount: widget.categoryItem.groupsCount,
            id: widget.categoryItem.id,
            isSubscribedTo: widget.categoryItem.isSubscribedTo,
            isValid: widget.categoryItem.isValid,
            name: widget.categoryItem.name,
            questionsCount: widget.categoryItem.questionsCount,
            subCategories: widget.categoryItem.subCategories);

        return SlidingSheetDialog(
          color: Colors.grey.shade50,
          padding: EdgeInsets.only(top: 18),
          elevation: 8,
          cornerRadius: 16,
          extendBody: false,
          dismissOnBackdropTap: true,
          footerBuilder: (context, state) {
            return Container(
              height: 50,
              child: saveButton(context),
            );
          },
          listener: (state) {
            if (state.isHidden) {
              widget.categoryItem.subCategories = newSubCategoriesItem;
              discoverMyInterestsAddInterestsBloc.add(
                  UpdateSubCategoryStateFromBottomSheet(
                      index: widget.index, items: widget.categoryItem));
            }
          },
          duration: Duration(milliseconds: 60),
          builder: (context, state) {
            return BlocProvider.value(
              value: discoverMyInterestsAddInterestsBloc,
              child: BlocListener<DiscoverMyInterestsAddInterestsBloc,
                  DiscoverMyInterestsAddInterestsState>(
                listener: (context, state) {
                  if (state is ChangeCategoryStateByClickItem) {
                    categoryResponse = state.categoryResponse;
                  }
                },
                child: BlocBuilder<DiscoverMyInterestsAddInterestsBloc,
                    DiscoverMyInterestsAddInterestsState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Container(
                          child: Center(
                            child: Material(
                              child: ListView(
                                padding: EdgeInsets.all(22),
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  showBottomNavigationTitle(),
                                  SizedBox(height: 6),
                                  Text(
                                    AppLocalizations.of(context).we_will_show_you_more_activity_from_the_sub_category_you_pick,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: showListOfItem(
                                        context, categoryResponse),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // saveButton(context, -10),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: 2,
                            decoration: new BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(7))),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget saveButton(BuildContext context) {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () {
        newSubCategoriesItem = addItemToNewSubCategoriesList();
        Navigator.pop(context);
      },
      height: 50,
      child: Center(
        child: Text(
          AppLocalizations.of(context).save,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      color: Colors.black,
    );
  }

  Widget showListOfItem(
      BuildContext context, CategoryResponse categoryResponse) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: categoryResponse.subCategories.map((item) {
        return InkWell(
          onTap: () {
            BlocProvider.of<DiscoverMyInterestsAddInterestsBloc>(context).add(
                ChangeMyInterestClickEvent(
                    categoryResponse: categoryResponse,
                    index: subCategoriesIndex[item.id]));
          },
          child: DiscoverMyInterestsAddSubCategoryItem(
            selected: item.isSubscribedTo,
            subCategory: item,
          ),
        );
      }).toList(),
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      verticalDirection: VerticalDirection.down,
    );
  }

  Widget showBottomNavigationTitle() {
    return Text(
      widget.categoryItem.name,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    );
  }
}
*/
