import 'package:arachnoit/application/search/search_bloc.dart';
import 'package:arachnoit/application/search_blogs/search_blogs_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/advance_search_tags_item.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:arachnoit/presentation/custom_widgets/search_tag_dialog.dart';
import 'package:arachnoit/presentation/screens/group_details_search/group_details_serach_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBlogsBottomSheetContent extends StatefulWidget {
  final SearchBloc searchBloc;
  SearchBlogsBottomSheetContent({this.searchBloc});
  @override
  State<StatefulWidget> createState() {
    return _SearchBlogsAndQuestionBottomSheetContent();
  }
}

class _SearchBlogsAndQuestionBottomSheetContent
    extends State<SearchBlogsBottomSheetContent> {
  TextEditingController _accountTypeController = TextEditingController();
  TextEditingController _mainCategoryController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();
  int accountTypeValue = -1;
  List<SearchModel> searchedList = List<SearchModel>();
  SearchBlogsBloc searchBlogsBloc;
  String categoryId, subCategoryId;
  List<SearchModel> selectedTagsItem = List<SearchModel>();
  Map<String, int> wrapTagItemsIndex = Map<String, int>();
  int orderByBlogs = -1;
  bool myFeed = false;
  @override
  void initState() {
    super.initState();
    searchBlogsBloc = serviceLocator<SearchBlogsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBlogsBloc>(
      create: (context) => searchBlogsBloc,
      child: BlocListener<SearchBlogsBloc, SearchBlogsState>(
        listener: (context, state) {
          if (state is LoadingState) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          } else if (state is GetAdvanceSearchMainCategorySuccess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) {
              _handelGetAdvanceSearchMainCategorySuccess(state);
            });
          } else if (state is GetAdvanceSearchSubCategorySuccess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) {
              _handelGetAdvanceSearchSubCategory(state);
            });
          } else if (state is GetAdvanceSearchAllTagsSuccess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                .then((value) {
              _handleGetAdvanceSearchAllTagsSuccess(state);
            });
          } else if (state is ChanagSelectedTagListState) {
            _handleChanagSelectedTagListState(state);
          } else if (state is ResetAdvanceSearchValuesState) {
            _handleResetAdvanceSearchValuesState();
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            GlobalPurposeFunctions.showToast(
              AppLocalizations
                  .of(context)
                  .check_your_internet_connection,
              context,
            );
          }
        },
        child: BlocBuilder<SearchBlogsBloc, SearchBlogsState>(
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
                              "Advanced Search:",
                              style: regularMontserrat(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10),
                            mainCategoryDropdownButton(context),
                            SizedBox(height: 10),
                            subCategoryDropdownButton(context),
                            SizedBox(height: 10),
                            accountType(context),
                            SizedBox(height: 10),
                            addTagsButton(context),
                            SizedBox(height: 5),
                            showTags(),
                            SizedBox(height: 5),
                            resetAndSearchButton(context),
                            SizedBox(height: 20),
                            Text(
                              "Sort by:",
                              style: regularMontserrat(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                orderByBlogs = 0;
                                Navigator.of(context).pop(addParam());
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.sort,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Normal Ordering",
                                    style: lightMontserrat(
                                      fontSize: 14,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                myFeed = true;
                                Navigator.of(context).pop(addParam());
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.question_answer_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "My Feed",
                                    style: lightMontserrat(
                                      fontSize: 14,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                orderByBlogs = 1;
                                Navigator.of(context).pop(addParam());
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.comment,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "My comments",
                                    style: lightMontserrat(
                                      fontSize: 14,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
  }

  void _handleResetAdvanceSearchValuesState() {
    _accountTypeController.text = "";
    _mainCategoryController.text = "";
    _subCategoryController.text = "";
    accountTypeValue = -1;
    searchedList.clear();
    categoryId = "";
    subCategoryId = "";
    selectedTagsItem.clear();
    wrapTagItemsIndex = Map<String, int>();
    orderByBlogs = -1;
    myFeed = false;
  }

  void _handleChanagSelectedTagListState(ChanagSelectedTagListState state) {
    wrapTagItemsIndex.clear();
    selectedTagsItem = state.tagsItem;
    for (int i = 0; i < selectedTagsItem.length; i++) {
      wrapTagItemsIndex[selectedTagsItem[i].id] = i;
    }
  }

  void _handleGetAdvanceSearchAllTagsSuccess(
      GetAdvanceSearchAllTagsSuccess state) {
    searchedList.clear();
    for (var i = 0; i < state.tagItems.length; i++) {
      searchedList.add(
          SearchModel(id: state.tagItems[i].id, name: state.tagItems[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchTagDialog(
              data: searchedList,
              wrapIdTagsItem: wrapTagItemsIndex,
            )).then((value) {
      if (value != null) {
        searchBlogsBloc.add(ChanagSelectedTagListEvent(tagsItem: value));
      }
    });
  }

  void _handelGetAdvanceSearchSubCategory(
      GetAdvanceSearchSubCategorySuccess state) {
    searchedList.clear();
    for (var i = 0; i < state.subCategories.length; i++) {
      searchedList.add(SearchModel(
          id: state.subCategories[i].id, name: state.subCategories[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: searchedList,
            )).then((val) {
      if (val != null) {
        subCategoryId = state.subCategories[val].id;
        _subCategoryController.text = state.subCategories[val].name;
      }
    });
  }

  void _handelGetAdvanceSearchMainCategorySuccess(
      GetAdvanceSearchMainCategorySuccess state) {
    searchedList.clear();
    for (var i = 0; i < state.categories.length; i++) {
      searchedList.add(SearchModel(
          id: state.categories[i].id, name: state.categories[i].name));
    }
    showDialog(
        context: context,
        builder: (context) => SearchDialog(
              data: searchedList,
            )).then((val) {
      if (val != null) {
        categoryId = state.categories[val].id;
        _mainCategoryController.text = state.categories[val].name;
      }
    });
  }

  Widget showTags() {
    return Wrap(
      children: selectedTagsItem.map((e) {
        return Padding(
          padding: EdgeInsets.only(left: 4, right: 4),
          child: InkWell(
              onTap: () {
                searchBlogsBloc.add(RemoveSelectedTagItem(
                    tagsItem: selectedTagsItem,
                    index: wrapTagItemsIndex[e.id]));
              },
              child: AdvanceSearchTagsItem(selectedTagsItem: e)),
        );
      }).toList(),
    );
  }

  Widget resetAndSearchButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              searchBlogsBloc.add(ResetAdvanceSearchValues());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Text(
                    "RESET",
                    textAlign: TextAlign.center,
                    style: mediumMontserrat(color: Colors.white, fontSize: 12),
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
              Navigator.of(context).pop(addParam());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    "SEARCH",
                    textAlign: TextAlign.center,
                    style: mediumMontserrat(color: Colors.white, fontSize: 12),
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
    );
  }

  Map<String, dynamic> addParam() {
    Map<String, dynamic> param = Map<String, dynamic>();
    List<String> tags = List<String>();
    for (SearchModel item in selectedTagsItem) {
      tags.add(item.id);
    }
    param = {
      "categoryId": categoryId,
      "subCategoryId": subCategoryId,
      "accountTypeId": accountTypeValue,
      "tagsId": tags,
      "orderByBlogs": orderByBlogs,
      "myFeed": myFeed,
      "isAdvanceSearch": true
    };
    widget.searchBloc.add(ProviderAdvanceSearch());
    return param;
  }

  Widget addTagsButton(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          searchBlogsBloc.add(GetAdvanceSearchAllTags());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ADD TAGS",
              style: mediumMontserrat(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.zero,
              bottomRight: Radius.circular(20)),
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget accountType(BuildContext context) {
    return DropDownTextField(
      hintText: 'Account Type',
      controller: _accountTypeController,
      errorText: null,
      handleTap: () {
        showDialog(context: context, builder: (context) => AccountTypeDialog())
            .then((value) {
          if (value != null) {
            accountTypeValue = value;
            _accountTypeController.text = value == 0
                ? AppLocalizations.of(context).individual
                : value == 1
                    ? AppLocalizations.of(context).enterprise
                    : AppLocalizations.of(context).researcher;
          }
        });
      },
    );
  }

  Widget subCategoryDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: AppLocalizations.of(context).subCategory,
      controller: _subCategoryController,
      errorText: null,
      handleTap: () {
        if (categoryId == null || categoryId.length == 0)
          GlobalPurposeFunctions.showToast(
            AppLocalizations.of(context).please_select_category,
            context,
          );
        else {
          searchBlogsBloc
              .add(GetAdvanceSearchSubCategory(categoryId: categoryId));
        }
      },
    );
  }

  Widget mainCategoryDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: 'Main Category',
      controller: _mainCategoryController,
      errorText: null,
      handleTap: () {
        searchBlogsBloc.add(GetAdvanceSearchMainCategory());
      },
    );
  }
}
