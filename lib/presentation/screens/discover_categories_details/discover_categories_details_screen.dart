import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/discover_categories_details/discover_categories_details_bloc.dart';
import '../../../infrastructure/common_response/category_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/discover_categories_details_sub_category_item.dart';
import '../../custom_widgets/discover_category_blog_item.dart';
import '../../custom_widgets/discover_category_group_item.dart';
import '../../custom_widgets/discover_category_question_item.dart';
import '../discover_Categories_sub_category_all_groups/discover_categories_sub_category_all_groups_screen.dart';
import '../discover_categories_sub_category_all_blogs/discover_categories_sub_category_all_blogs_screen.dart';
import '../discover_categories_sub_category_all_questions/discover_categories_sub_category_all_questions_screen.dart';

class DiscoverCategriesDetailsScreen extends StatefulWidget {
  static const routeName = '/discover_categoris_details_screen';

  DiscoverCategriesDetailsScreen({Key key, @required this.category})
      : super(key: key);
  final CategoryResponse category;

  @override
  _DiscoverCategriesDetailsScreenState createState() =>
      _DiscoverCategriesDetailsScreenState();
}

class _DiscoverCategriesDetailsScreenState
    extends State<DiscoverCategriesDetailsScreen> {
  DiscoverCategoriesDetailsBloc detailsBloc;
  int listViewRefIndex = 0;

  @override
  void initState() {
    super.initState();
    detailsBloc = serviceLocator<DiscoverCategoriesDetailsBloc>();
    detailsBloc.add(FetchSubCategoryDataEvent(
      selectedItemIndex: 0,
      context: context,
      categoryId: widget.category.id,
      subCategoryId: widget.category.subCategories[0].id,
      blogsCount: widget.category.subCategories[0].blogsCount,
      questionsCount: widget.category.subCategories[0].questionsCount,
      groupsCount: widget.category.subCategories[0].groupsCount,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: widget.category.name,
      ),
      body: SingleChildScrollView(
        child: BlocProvider<DiscoverCategoriesDetailsBloc>(
          create: (context) => detailsBloc,
          child: BlocListener<DiscoverCategoriesDetailsBloc,
              DiscoverCategoriesDetailsState>(
            listener: (context, state) {},
            child: Column(
              children: [
                BlocBuilder<DiscoverCategoriesDetailsBloc,
                    DiscoverCategoriesDetailsState>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Container(
                        height: 40,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 5),
                          itemBuilder: (context, i) => Padding(
                            padding: EdgeInsets.only(
                              right: 5,
                              left: 5,
                            ),
                            child: InkWell(
                              onTap: () {
                                listViewRefIndex = i;
                                if (state.selectedItemIndex != i)
                                  BlocProvider.of<
                                      DiscoverCategoriesDetailsBloc>(
                                      context)
                                      .add(FetchSubCategoryDataEvent(
                                    selectedItemIndex: i,
                                    context: context,
                                    categoryId: widget.category.id,
                                    subCategoryId:
                                    widget.category.subCategories[i].id,
                                    blogsCount: widget
                                        .category.subCategories[i].blogsCount,
                                    questionsCount: widget.category
                                        .subCategories[i].questionsCount,
                                    groupsCount: widget
                                        .category.subCategories[i].groupsCount,
                                  ));
                              },
                              child: DiscoverCategoriesDetailsSubCategoryItem(
                                subCategory: widget.category.subCategories[i],
                                selected:
                                state.selectedItemIndex == i ?true : false,
                              ),
                            ),
                          ),
                          itemCount: widget.category.subCategories.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<DiscoverCategoriesDetailsBloc,
                    DiscoverCategoriesDetailsState>(
                  builder: (context, state) {
                    if (state.isError)
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: BlocError(
                            context: context,
                            blocErrorState: BlocErrorState.userError,
                            function: () {
                              BlocProvider.of<DiscoverCategoriesDetailsBloc>(
                                  context)
                                  .add(FetchSubCategoryDataEvent(
                                selectedItemIndex: listViewRefIndex,
                                categoryId: widget.category.id,
                                subCategoryId: widget.category
                                    .subCategories[listViewRefIndex].id,
                                blogsCount: widget.category
                                    .subCategories[listViewRefIndex].blogsCount,
                                questionsCount: widget
                                    .category
                                    .subCategories[listViewRefIndex]
                                    .questionsCount,
                                groupsCount: widget
                                    .category
                                    .subCategories[listViewRefIndex]
                                    .groupsCount,
                                context: context,
                              ));
                            }),
                      );
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget
                            .category
                            .subCategories[state.selectedItemIndex]
                            .blogsCount !=
                            0 &&
                            state.blogs.length > 0)
                          BlocBuilder<DiscoverCategoriesDetailsBloc,
                              DiscoverCategoriesDetailsState>(
                            buildWhen: (previous, current) =>
                            previous.blogs != current.blogs,
                            builder: (context, state) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context).blogs,
                                            style: boldMontserrat(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          child: Text(
                                            '${AppLocalizations.of(context).see_all}(' +
                                                widget
                                                    .category
                                                    .subCategories[
                                                state.selectedItemIndex]
                                                    .blogsCount
                                                    .toString() +
                                                ')',
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.visible,
                                            style: mediumMontserrat(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                DiscoverCategoriesSubCategoryAllBlogsScreen
                                                    .routeName,
                                                arguments: widget
                                                    .category.subCategories[
                                                state.selectedItemIndex]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 160,
                                    child: ListView.builder(
                                      padding:
                                      EdgeInsets.only(left: 8, right: 8),
                                      itemBuilder: (context, i) =>
                                          DiscoverCategoryBlogItem(
                                            blog: state.blogs[i],
                                          ),
                                      itemCount: state.blogs.length,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        if (widget
                            .category
                            .subCategories[state.selectedItemIndex]
                            .groupsCount !=
                            0 &&
                            state.groups.length > 0 &&
                            GlobalPurposeFunctions.getUserObject() != null)
                          BlocBuilder<DiscoverCategoriesDetailsBloc,
                              DiscoverCategoriesDetailsState>(
                            buildWhen: (previous, current) =>
                            previous.groups != current.groups,
                            builder: (context, state) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${AppLocalizations.of(context).groups}:",
                                            style: boldMontserrat(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          child: Text(
                                            '${AppLocalizations.of(context).see_all}(' +
                                                (widget
                                                    .category
                                                    .subCategories[state
                                                    .selectedItemIndex]
                                                    .groupsCount -
                                                    1)
                                                    .toString() +
                                                ')',
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.visible,
                                            style: mediumMontserrat(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                DiscoverCategoriesSubCategoryAllGroupsScreen
                                                    .routeName,
                                                arguments: widget
                                                    .category.subCategories[
                                                state.selectedItemIndex]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 170,
                                    child: ListView.builder(
                                      padding:
                                      EdgeInsets.only(left: 8, right: 8),
                                      itemBuilder: (context, i) =>
                                          DiscoverCategoryGroupItem(
                                              group: state.groups[i]),
                                      itemCount: state.groups.length,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        if (widget
                            .category
                            .subCategories[state.selectedItemIndex]
                            .questionsCount !=
                            0 &&
                            state.questions.length != 0)
                          BlocBuilder<DiscoverCategoriesDetailsBloc,
                              DiscoverCategoriesDetailsState>(
                            buildWhen: (previous, current) =>
                            previous.questions != current.questions,
                            builder: (context, state) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${AppLocalizations.of(context).questionAndAnswer}:",
                                            style: boldMontserrat(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          child: Text(
                                            '${AppLocalizations.of(context).see_all}(' +
                                                widget
                                                    .category
                                                    .subCategories[
                                                state.selectedItemIndex]
                                                    .questionsCount
                                                    .toString() +
                                                ')',
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.visible,
                                            style: mediumMontserrat(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                DiscoverCategoriesSubCategoryAllQuestionsScreen
                                                    .routeName,
                                                arguments: widget
                                                    .category.subCategories[
                                                state.selectedItemIndex]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 120,
                                    child: ListView.builder(
                                      padding:
                                      EdgeInsets.only(left: 8, right: 8),
                                      itemBuilder: (context, i) =>
                                          DiscoverCategoryQuestionItem(
                                            question: state.questions[i],
                                          ),
                                      itemCount: state.questions.length,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
