import 'dart:ui';

import 'package:arachnoit/application/add_question/add_question_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/home_qaa/response/qaa_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question_screen.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question_sub_categories.dart';
import 'package:arachnoit/presentation/screens/add_question/question_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';

class AddQuestion extends StatefulWidget {
  static const routeName = 'addQuestionPage';

  const AddQuestion(
      {Key key, this.questionId, this.groupId, this.isUpdateQuestion = false, this.item})
      : super(key: key);

  final String questionId;
  final String groupId;
  final bool isUpdateQuestion;
  final QaaResponse item;
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestion> with SingleTickerProviderStateMixin {
  TabController _tabController;
  ValueNotifier<int> changeTabBarValue = ValueNotifier(0);
  AddQuestionBloc addQuestionBloc;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.animation.addListener(_handleTabSelection);
    addQuestionBloc = serviceLocator<AddQuestionBloc>();
    if (widget.isUpdateQuestion) {
      addQuestionBloc.categoriesId = widget.item.categoryId;
      addQuestionBloc.categoryName = widget.item.category;
      int leng = widget?.item?.subCategories?.length ?? 0;
      if (leng == 0) {
        addQuestionBloc.subCategoryItem
            .add(SubCategoryResponse(id: widget.item.subCategoryId, name: widget.item.subCategory));
      } else {
        for (SubCategoryResponse item in widget.item.subCategories) {
          addQuestionBloc.subCategoryItem.add(item);
        }
      }
      addQuestionBloc.add(AddQuestionGetSubCategoryEvent(widget.item.categoryId));
      _tabController.animateTo(2);
    }

    super.initState();
  }

  _handleTabSelection() {
    if (addQuestionBloc.categoriesId.length == 0) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(context).please_select_category, context);
      _tabController.animateTo(0);
    } else if (addQuestionBloc.subCategoryItem.length == 0 &&
        _tabController.animation.value.round() == 2) {
      GlobalPurposeFunctions.showToast(
          AppLocalizations.of(context).select_your_sub_categories, context);
      _tabController.animateTo(1);
    } else {
      changeTabBarValue.value = _tabController.animation.value.round();
    }
  }

  @override
  // ignore: must_call_super
  void didChangeDependencies() {}
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddQuestionBloc>(
      create: (contxt) => addQuestionBloc,
      child: BlocBuilder<AddQuestionBloc, AddQuestionState>(
        builder: (context, state) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.0), // here the desired height
                child: AppBar(
                  toolbarHeight: 100,
                  leadingWidth: 10,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  backgroundColor: Colors.grey.shade200,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  title: ValueListenableBuilder<int>(
                      valueListenable: changeTabBarValue,
                      builder: (context, value, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            TabBar(
                                controller: _tabController,
                                labelColor: Theme.of(context).primaryColor,
                                indicatorColor: Colors.transparent,
                                // onTap: (x) {
                                //   // if ((x == 1 || x == 3) &&
                                //   //     addQuestionBloc.categoriesId.length == 0) {
                                //   //   GlobalPurposeFunctions.showToast(
                                //   //       "Please Select categori first", context);
                                //   // } else if (x == 2 &&
                                //   //     addQuestionBloc.subCategoryItem.length == 0) {
                                //   //   GlobalPurposeFunctions.showToast(
                                //   //       "Please Select sub categori first", context);
                                //   // } else {
                                //   //   _tabController.animateTo(x);
                                //   // }
                                // },
                                labelStyle: boldMontserrat(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12,
                                ),
                                tabs: [
                                  topTitle("1", value == 0),
                                  topTitle("2", value == 1),
                                  topTitle("3", value == 2),
                                ]),
                            SizedBox(height: 12),
                            Center(
                                child: Text(
                                    (value == 0)
                                        ? AppLocalizations.of(context).select_your_category
                                        : (value == 1)
                                            ? AppLocalizations.of(context)
                                                .select_your_sub_categories
                                            : AppLocalizations.of(context).add_question,
                                    style: mediumMontserrat(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ))),
                            SizedBox(height: 4),
                          ],
                        );
                      }),
                ),
              ),
              body: showTitle());
        },
      ),
    );
  }

  Widget showTitle() {
    return NotificationListener<ScrollUpdateNotification>(
        onNotification: (scrollEnd) {
          if (scrollEnd.metrics.axis == Axis.horizontal) {
            // print("scrollEnd.metrics.axis ${scrollEnd.metrics.pixels}");

            // final maxScroll = scrollEnd.metrics.pixels;
            var x = scrollEnd.metrics;
            double x1 = x.maxScrollExtent * (1 / 3);
            double x2 = x.maxScrollExtent * (2 / 3);

            if (x.pixels >= 0 && x1 > x.pixels) {
              changeTabBarValue.value = 0;
              _tabController.animateTo(0);
            } else if (x.pixels >= x1 && x2 > x.pixels) {
              changeTabBarValue.value = 1;
              _tabController.animateTo(1);
            } else {
              _tabController.animateTo(2);
              changeTabBarValue.value = 2;
            }
          }
        },
        child: ValueListenableBuilder<int>(
          valueListenable: changeTabBarValue,
          builder: (context, value, _) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 55),
                  child: TabBarView(
                    physics: (addQuestionBloc.categoriesId.length == 0 &&
                            changeTabBarValue.value == 0)
                        ? LeftBlockedScrollPhysics()
                        : (changeTabBarValue.value == 0 && addQuestionBloc.categoriesId.length != 0)
                            ? BouncingScrollPhysics()
                            : (addQuestionBloc.subCategoryItem.length == 0 &&
                                    changeTabBarValue.value == 1)
                                ? LeftBlockedScrollPhysics()
                                : BouncingScrollPhysics(),
                    controller: _tabController,
                    children: [
                      QuestionCategories(
                          tabController: _tabController, addQuestionBloc: addQuestionBloc),
                      AddQuestionSubCategories(
                        addQuestionBloc: addQuestionBloc,
                        isUpdateQuestion: widget.isUpdateQuestion,
                        item: widget.item,
                      ),
                      AddQuestionScreen(
                          addQuestionBloc: addQuestionBloc,
                          isUpdateQuestion: widget.isUpdateQuestion,
                          item: widget.item,
                          groupId: widget.groupId,
                          questionId: widget.questionId),
                    ],
                  ),
                ),
                ValueListenableBuilder<int>(
                    valueListenable: changeTabBarValue,
                    builder: (context, value, _) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          color: Colors.grey.shade200,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (value != 2)
                                  ? Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          if (changeTabBarValue.value == 0 &&
                                              addQuestionBloc.categoriesId.length == 0) {
                                            GlobalPurposeFunctions.showToast(
                                                AppLocalizations.of(context).please_select_category,
                                                context);
                                          } else if (changeTabBarValue.value == 1 &&
                                              addQuestionBloc.subCategoryItem.length == 0 &&
                                              _tabController.animation.value.round() == 2) {
                                            GlobalPurposeFunctions.showToast(
                                                AppLocalizations.of(context)
                                                    .select_your_sub_categories,
                                                context);
                                          } else
                                            _tabController
                                                .animateTo((_tabController.index + 1) % 3);
                                        },
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context).next,
                                            style: mediumMontserrat(
                                                color: Theme.of(context).accentColor, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              (value != 0)
                                  ? Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          if (changeTabBarValue.value == 0 &&
                                              addQuestionBloc.categoriesId.length == 0) {
                                            GlobalPurposeFunctions.showToast(
                                                AppLocalizations.of(context).please_select_category,
                                                context);
                                          } else if (changeTabBarValue.value == 1 &&
                                              addQuestionBloc.subCategoryItem.length == 0 &&
                                              _tabController.animation.value.round() == 2) {
                                            GlobalPurposeFunctions.showToast(
                                                AppLocalizations.of(context)
                                                    .subCategory_cannot_be_empty,
                                                context);
                                          } else
                                            _tabController
                                                .animateTo((_tabController.index - 1) % 3);
                                        },
                                        child: Text(AppLocalizations.of(context).previous,
                                            style: mediumMontserrat(
                                                color: Theme.of(context).accentColor,
                                                fontSize: 16)),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    })
              ],
            );
          },
        ));
  }

  Widget topTitle(String title, bool isClicked) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(120),
      child: Container(
        color: !isClicked ? Colors.white : Theme.of(context).accentColor,
        width: 30,
        height: 30,
        child: Center(
          child: Text(
            title,
            style: mediumMontserrat(
                fontSize: 14, color: isClicked ? Colors.white : Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }
}
