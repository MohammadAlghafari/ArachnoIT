import 'dart:ui';

import 'package:arachnoit/application/search/search_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/recreate_widget.dart';
import 'package:arachnoit/presentation/custom_widgets/search_blogs_bottom_sheet_content.dart';
import 'package:arachnoit/presentation/custom_widgets/search_groups_bottom_sheet_content.dart';
import 'package:arachnoit/presentation/custom_widgets/search_provider_bottom_sheet_content.dart';
import 'package:arachnoit/presentation/custom_widgets/search_questions_bottom_sheet_content.dart';
import 'package:arachnoit/presentation/screens/search_blogs/search_blogs_screen.dart';
import 'package:arachnoit/presentation/screens/search_group/search_group_screen.dart';
import 'package:arachnoit/presentation/screens/search_provider/search_provider_screen.dart';
import 'package:arachnoit/presentation/screens/search_questions/search_questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search_screen';
  final bool isLoginIn;
  const SearchScreen({Key key, this.isLoginIn = false}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Widget> arrayBottomSheetBody;
  SearchBloc searchBloc;
  bool wantKeepAlive = true;
  bool fromAdvanceSearch = false;
  TextEditingController _searchEditingController;
  Map<String, dynamic> providerParam = new Map<String, dynamic>();
  Map<String, dynamic> groupParam = new Map<String, dynamic>();
  Map<String, dynamic> blogsParam = new Map<String, dynamic>();
  Map<String, dynamic> questionParam = new Map<String, dynamic>();

  dynamic searchText;
  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    if (widget.isLoginIn)
      _tabController = TabController(vsync: this, length: 4);
    else
      _tabController = TabController(vsync: this, length: 3);

    _tabController.animation.addListener(_handleTabSelection);
    searchBloc = serviceLocator<SearchBloc>();
    if (widget.isLoginIn)
      arrayBottomSheetBody = [
        SearchProviderBottomSheetContent(searchBloc: searchBloc),
        SearchGroupsBottomSheetContent(searchBloc: searchBloc),
        SearchBlogsBottomSheetContent(searchBloc: searchBloc),
        SearchQuestionsBottomSheetContent(searchBloc: searchBloc)
      ];
    else {
      arrayBottomSheetBody = [
        SearchProviderBottomSheetContent(searchBloc: searchBloc),
        SearchBlogsBottomSheetContent(searchBloc: searchBloc),
        SearchQuestionsBottomSheetContent(searchBloc: searchBloc)
      ];
    }
  }

  @override
  // ignore: must_call_super
  void didChangeDependencies() {}
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    searchBloc.add(ChangeSearchScreenEvent(
        currentIndex: _tabController.animation.value.round()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: (widget.isLoginIn) ? 4 : 3,
        child: BlocProvider<SearchBloc>(
          create: (context) => searchBloc,
          child: BlocBuilder<SearchBloc, SearchState>(
              buildWhen: (last, current) =>
                  last.shouldReplaceState != current.shouldReplaceState,
              builder: (context, state) {
                return Scaffold(
                    backgroundColor: Colors.grey[300],
                    appBar: AppBar(
                      elevation: 0.0,
                      automaticallyImplyLeading: true,
                      iconTheme: IconThemeData(
                        color: Theme.of(context).primaryColor,
                      ),
                      title: TextField(
                        controller: _searchEditingController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: AppLocalizations.of(context).search),
                        onSubmitted: (query) {
                          searchBloc.add(SearchFromTextEvent());
                          searchText = query;
                          groupParam.clear();
                          providerParam.clear();
                          blogsParam.clear();
                          questionParam.clear();
                        },
                      ),
                      actions: [
                        BlocBuilder<SearchBloc, SearchState>(
                          builder: (context, state) {
                            return IconButton(
                              icon: Icon(Icons.filter_list),
                              onPressed: () {
                                showBottomSheet(
                                        context,
                                        arrayBottomSheetBody[
                                            state.currentIndex])
                                    .then((value) {
                                  if (value != null) {
                                    if (widget.isLoginIn) {
                                      if (state.currentIndex == 0) {
                                        providerParam = value;
                                      } else if (state.currentIndex == 1) {
                                        groupParam = value;
                                      } else if (state.currentIndex == 2) {
                                        blogsParam = value;
                                      } else if (state.currentIndex == 3) {
                                        questionParam = value;
                                      }
                                    } else {
                                      if (state.currentIndex == 0) {
                                        providerParam = value;
                                      } else if (state.currentIndex == 1) {
                                        blogsParam = value;
                                      } else if (state.currentIndex == 2) {
                                        questionParam = value;
                                      }
                                    }
                                    _searchEditingController.clear();
                                    searchText = null;
                                  }
                                });
                              },
                            );
                          },
                        )
                      ],
                      bottom: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        indicatorColor: Theme.of(context).primaryColor,
                        labelStyle: mediumMontserrat(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontSize: 15,
                        ),
                        onTap: (value) {
                          BlocProvider.of<SearchBloc>(context)
                            ..add(ChangeSearchScreenEvent(
                                currentIndex: _tabController.index));
                        },
                        tabs: (widget.isLoginIn)
                            ? [
                                Tab(
                                  text: AppLocalizations.of(context).providers,
                                ),
                                Tab(
                                  text: AppLocalizations.of(context).groups,
                                ),
                                Tab(
                                  text: AppLocalizations.of(context).blogs,
                                ),
                                Tab(
                                  text: AppLocalizations.of(context)
                                      .questionAndAnswer,
                                ),
                              ]
                            : [
                                Tab(
                                  text: AppLocalizations.of(context).providers,
                                ),
                                Tab(
                                  text: AppLocalizations.of(context).blogs,
                                ),
                                Tab(
                                  text: AppLocalizations.of(context)
                                      .questionAndAnswer,
                                ),
                              ],
                      ),
                    ),
                    body: TabBarView(
                      controller: _tabController,
                      children: (widget.isLoginIn)
                          ? [
                              showProviderBody(state),
                              showGroupBody(state),
                              showBlogsBody(state),
                              showQuestionBody(state),
                            ]
                          : [
                              showProviderBody(state),
                              showBlogsBody(state),
                              showQuestionBody(state),
                            ],
                    ));
              }),
        ));
  }

  Widget showQuestionBody(SearchState state) {
    return RecreateWidget(
      shouldRecreate: state.shouldDestroyWidget,
      child: SearchQuestionScreen(
        shouldDestroyWidget: state.shouldDestroyWidget ?? false,
        categoryId: questionParam["categoryId"] ?? "",
        subCategoryId: questionParam["subCategoryId"] ?? "",
        accountTypeId: questionParam["accountTypeId"] ?? -1,
        orderByQuestions: questionParam["orderByQuestions"] ?? -1,
        tagsId: questionParam["tagsId"] ?? const <String>[],
        isAdvanceSearch: questionParam["isAdvanceSearch"] ?? false,
        searchText: searchText,
      ),
    );
  }

  Widget showBlogsBody(SearchState state) {
    return RecreateWidget(
      shouldRecreate: state.shouldDestroyWidget,
      child: SearchBlogsScreen(
        shouldDestroyWidget: state.shouldDestroyWidget,
        accountTypeId: blogsParam["accountTypeId"] ?? -1,
        categoryId: blogsParam["categoryId"] ?? "",
        subCategoryId: blogsParam["subCategoryId"] ?? "",
        myFeed: blogsParam["myFeed"] ?? false,
        orderByBlogs: blogsParam["orderByBlogs"] ?? -1,
        tagsId: blogsParam["tagsId"] ?? const <String>[],
        searchText: searchText,
        isAdvanceSearch: blogsParam["isAdvanceSearch"] ?? false,
      ),
    );
  }

  Widget showGroupBody(SearchState state) {
    return RecreateWidget(
      shouldRecreate: state.shouldDestroyWidget,
      child: SearchGroupScreen(
        shouldDestroyWidget: state.shouldDestroyWidget,
        isAdvanceSearch: groupParam["isAdvanceSearch"] ?? false,
        categoryId: groupParam["categoryId"] ?? "",
        subCategoryId: groupParam["subCategoryId"] ?? "",
        textSearch: searchText,
      ),
    );
  }

  Widget showProviderBody(SearchState state) {
    return RecreateWidget(
      shouldRecreate: state.shouldDestroyWidget,
      child: SearchProviderScreen(
        shouldDestroyWidget: state.shouldDestroyWidget,
        searchTextQuery: searchText,
        accountTypeId: providerParam['accountTypeId'] ?? "",
        cityId: providerParam['cityId'] ?? "",
        countryId: providerParam['countryId'] ?? "",
        gender: providerParam["gender"] ?? -1,
        subSpecificationId: providerParam["subSpecificationId"] ?? "",
        isAdvanceSearch: providerParam["isAdvanceSearch"] ?? false,
        serviceId: providerParam["serviceId"] ?? "",
        specificationsIds:
            providerParam["specificationsIds"] ?? const <String>[],
      ),
    );
  }

  Future showBottomSheet(BuildContext context, Widget bottomSheetContent) {
    return showModalBottomSheet<dynamic>(
        elevation: 0.0,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext bc) {
          return bottomSheetContent;
        });
  }
}
