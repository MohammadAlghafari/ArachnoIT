import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/presentation/custom_widgets/advance_search_tags_item.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:arachnoit/presentation/custom_widgets/search_tag_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/group_details_search/group_details_search_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../injections.dart';
import '../../custom_widgets/recreate_widget.dart';
import '../group_details_search_blogs/group_details_search_blogs_screen.dart';
import '../group_details_search_questions/group_details_search_questions_screen.dart';

class GroupDetailsSearchScreen extends StatefulWidget {
  static const routeName = '/group_details_search_screen';

  const GroupDetailsSearchScreen({Key key, @required this.groupId})
      : super(key: key);
  final String groupId;

  @override
  _GroupDetailsSearchScreenState createState() =>
      _GroupDetailsSearchScreenState();
}

class _GroupDetailsSearchScreenState extends State<GroupDetailsSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  GroupDetailsSearchBloc groupDetailsSearchBloc;

  @override
  void initState() {
    super.initState();
    groupDetailsSearchBloc = serviceLocator<GroupDetailsSearchBloc>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocProvider(
        create: (context) => groupDetailsSearchBloc,
        child: BlocBuilder<GroupDetailsSearchBloc, GroupDetailsSearchState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).primaryColor,
                  ),
                  title: TextField(
                    cursorColor: Theme.of(context).accentColor,
                    textInputAction: TextInputAction.search,
                    controller: _searchController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: AppLocalizations.of(context).search),
                    onSubmitted: (searchText) {
                      BlocProvider.of<GroupDetailsSearchBloc>(context)
                          .add(SearchTextSubmittedEvent(query: searchText));
                    },
                  ),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          _showBlogsAndQuestionsFilterBottomSheet(
                            context,
                          ).then((value) {
                            Map<String, dynamic> params = value;
                            String categoryId = params['mainCategoryId'];
                            String subCategoryId = params['subCategoryId'];
                            int accountType = params['accountType'];
                            List<String> tagsId = params['tagsId'];
                            BlocProvider.of<GroupDetailsSearchBloc>(context)
                                .add(AdvancedSearchSubmittedEvent(
                              categoryId: categoryId,
                              subCategoryId: subCategoryId,
                              accountType: accountType,
                              tagsId: tagsId,
                            ));
                            _searchController.text = '';
                          });
                        })
                  ],
                  bottom: TabBar(
                    labelColor: Theme.of(context).accentColor,
                    indicatorColor: Theme.of(context).accentColor,
                    labelStyle: semiBoldMontserrat(
                      color: Theme
                          .of(context)
                          .accentColor,
                      fontSize: 14,
                    ),
                    onTap: (value) {},
                    tabs: [
                      Tab(
                        text: AppLocalizations.of(context).blogs,
                      ),
                      Tab(
                        text: AppLocalizations.of(context).questionAndAnswer,
                      ),
                    ],
                  ),
                ),
                body: TabBarView(children: [
                  RecreateWidget(
                    child: GroupDetailsSearchBlogsScreen(
                      searchText: state.searchText,
                      groupId: widget.groupId,
                      categoryId: state.categoryId,
                      subCategoryId: state.subCategoryId,
                      accountType: state.accountType,
                      shouldDestroyWidget: state.shouldDestroyWidget,
                      tagsId: state.tagsId,
                    ),
                    shouldRecreate: state.shouldDestroyWidget,
                  ),
                  RecreateWidget(
                    child: GroupDetailsSearchQuestionsScreen(
                      searchText: state.searchText,
                      groupId: widget.groupId,
                      categoryId: state.categoryId,
                      subCategoryId: state.subCategoryId,
                      accountType: state.accountType,
                      shouldDestroyWidget: state.shouldDestroyWidget,
                      tagsId: state.tagsId,
                    ),
                    shouldRecreate: state.shouldDestroyWidget,
                  ),
                ]),
              );
            }),
      ),
    );
  }

  Future _showBlogsAndQuestionsFilterBottomSheet(BuildContext context,) {
    CategoryResponse category;
    SubCategoryResponse subCategory;
    int accountType;
    List<SearchModel> searchedList = [];
    TextEditingController mainCategoryController = TextEditingController();
    TextEditingController subCategoryController = TextEditingController();
    TextEditingController accountTypeController = TextEditingController();
    List<SearchModel> selectedTagsItem = List<SearchModel>();
    Map<String, int> wrapTagItemsIndex = Map<String, int>();
    return showModalBottomSheet<dynamic>(
        elevation: 0.0,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext bc) {
          return BlocProvider.value(
            value: serviceLocator<GroupDetailsSearchBloc>(),
            child:
            BlocListener<GroupDetailsSearchBloc, GroupDetailsSearchState>(
              listener: (context, state) {
                if (state is LoadingState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, true);
                } else if (state is SearchCategoriesState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.categories.length; i++) {
                      searchedList.add(SearchModel(
                          id: state.categories[i].id,
                          name: state.categories[i].name));
                    }
                    showDialog(
                        context: context,
                        builder: (context) => SearchDialog(
                          data: searchedList,
                        )).then((val) {
                      if (val != null) {
                        category = state.categories[val];
                        mainCategoryController.text = category.name;
                      }
                    });
                  });
                } else if (state is SearchSubCategoriesState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.subCategories.length; i++) {
                      searchedList.add(SearchModel(
                          id: state.subCategories[i].id,
                          name: state.subCategories[i].name));
                    }
                    showDialog(
                        context: context,
                        builder: (context) => SearchDialog(
                          data: searchedList,
                        )).then((val) {
                      if (val != null) {
                        subCategory = state.subCategories[val];
                        subCategoryController.text = subCategory.name;
                      }
                    });
                  });
                } else if (state is SearchAddTagsState) {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false)
                      .then((value) {
                    searchedList.clear();
                    for (var i = 0; i < state.tagItems.length; i++) {
                      searchedList.add(SearchModel(
                          id: state.tagItems[i].id,
                          name: state.tagItems[i].name));
                    }
                    showDialog(
                        context: context,
                        builder: (context) => SearchTagDialog(
                          data: searchedList,
                          wrapIdTagsItem: wrapTagItemsIndex,
                        )).then((value) {
                      if (value != null) {
                        BlocProvider.of<GroupDetailsSearchBloc>(context)
                            .add(ChanagSelectedTagListEvent(tagsItem: value));
                      }
                    });
                  });
                } else if (state is ChanagSelectedTagListState) {
                  wrapTagItemsIndex.clear();
                  selectedTagsItem = state.tagsItem;
                  for (int i = 0; i < selectedTagsItem.length; i++) {
                    wrapTagItemsIndex[selectedTagsItem[i].id] = i;
                  }
                } else {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false);
                }
              },
              child:
              BlocBuilder<GroupDetailsSearchBloc, GroupDetailsSearchState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white),
                      child: Wrap(
                        children: [
                          Container(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).advance_search,
                                    style: regularMontserrat(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  DropDownTextField(
                                    hintText: AppLocalizations.of(context)
                                        .main_category,
                                    controller: mainCategoryController,
                                    errorText: null,
                                    handleTap: () {
                                      BlocProvider.of<GroupDetailsSearchBloc>(
                                          context)
                                          .add(GetAdvancedSearchCategories());
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropDownTextField(
                                    hintText: AppLocalizations.of(context)
                                        .subCategory,
                                    controller: subCategoryController,
                                    errorText: null,
                                    handleTap: () {
                                      mainCategoryController.text.isEmpty
                                          ? GlobalPurposeFunctions.showToast(
                                        AppLocalizations.of(context)
                                            .please_select_category,
                                        context,
                                      )
                                          : BlocProvider.of<
                                          GroupDetailsSearchBloc>(
                                          context)
                                          .add(
                                          GetAdvancedSearchSubCategories(
                                            categoryId: category.id,
                                          ));
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropDownTextField(
                                    hintText: AppLocalizations.of(context)
                                        .account_type,
                                    controller: accountTypeController,
                                    errorText: null,
                                    handleTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AccountTypeDialog())
                                          .then((value) {
                                        if (value != null) {
                                          accountType = value;
                                          accountTypeController.text = value ==
                                              0
                                              ? AppLocalizations.of(context)
                                              .individual
                                              : value == 1
                                              ? AppLocalizations.of(context)
                                              .enterprise
                                              : AppLocalizations.of(context)
                                              .researcher;
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: FlatButton(
                                      onPressed: () {
                                        BlocProvider.of<GroupDetailsSearchBloc>(
                                            context)
                                          ..add(GetAdvanceSearchAddTags());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)
                                                .add_tags,
                                            style: regularMontserrat(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.tag,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      shape: GlobalPurposeFunctions
                                          .buildButtonBorder(),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Wrap(
                                    children: selectedTagsItem.map((e) {
                                      return Padding(
                                        padding:
                                        EdgeInsets.only(left: 4, right: 4),
                                        child: InkWell(
                                            onTap: () {
                                              BlocProvider.of<
                                                  GroupDetailsSearchBloc>(
                                                  context)
                                                  .add(RemoveSelectedTagItem(
                                                  tagsItem:
                                                  selectedTagsItem,
                                                  index: wrapTagItemsIndex[
                                                  e.id]));
                                            },
                                            child: AdvanceSearchTagsItem(
                                                selectedTagsItem: e)),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            mainCategoryController.text = '';
                                            subCategoryController.text = '';
                                            accountTypeController.text = '';
                                            category = null;
                                            subCategory = null;
                                            accountType = null;
                                            wrapTagItemsIndex.clear();
                                            List<SearchModel> searchModel =
                                            List<SearchModel>();
                                            BlocProvider.of<
                                                GroupDetailsSearchBloc>(
                                                context)
                                                .add(ChanagSelectedTagListEvent(
                                                tagsItem: searchModel));
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          color: Theme.of(context).accentColor,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 2,
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .reset,
                                                  textAlign: TextAlign.center,
                                                  style: regularMontserrat(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.settings_backup_restore,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () {
                                            List<String> tagsId =
                                            List<String>();
                                            for (int i = 0;
                                            i < selectedTagsItem.length;
                                            i++)
                                              tagsId
                                                  .add(selectedTagsItem[i].id);
                                            Map<String, dynamic> params = {
                                              'mainCategoryId': category != null
                                                  ? category.id
                                                  : '',
                                              'subCategoryId':
                                              subCategory != null
                                                  ? subCategory.id
                                                  : '',
                                              'accountType': accountType,
                                              'tagsId': tagsId
                                            };
                                            Navigator.of(context).pop(params);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .search,
                                                  textAlign: TextAlign.center,
                                                  style: regularMontserrat(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

class AccountTypeDialog extends StatelessWidget {
  const AccountTypeDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      AppLocalizations.of(context).account_type,
                      style: semiBoldMontserrat(
                        color: Theme.of(context).accentColor,
                        fontSize: 22,
                      ),
                    ),
                  )),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(0);
                },
                splashColor: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 14.0),
                  child: Text(
                    AppLocalizations.of(context).individual,
                    textAlign: TextAlign.start,
                    style: lightMontserrat(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(1);
                },
                splashColor: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 14.0),
                  child: Text(
                    AppLocalizations.of(context).enterprise,
                    textAlign: TextAlign.start,
                    style: lightMontserrat(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(2);
                },
                splashColor: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 14.0),
                  child: Text(
                    AppLocalizations.of(context).researcher,
                    textAlign: TextAlign.start,
                    style: lightMontserrat(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
