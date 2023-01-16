import 'package:arachnoit/application/search/search_bloc.dart';
import 'package:arachnoit/application/search_question/search_question_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/advance_search_tags_item.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:arachnoit/presentation/custom_widgets/search_tag_dialog.dart';
import 'package:arachnoit/presentation/custom_widgets/show_svg.dart';
import 'package:arachnoit/presentation/screens/group_details_search/group_details_serach_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchQuestionsBottomSheetContent extends StatefulWidget {
  final SearchBloc searchBloc;
  SearchQuestionsBottomSheetContent({this.searchBloc});
  @override
  State<StatefulWidget> createState() {
    return _SearchQuestionsBottomSheetContent();
  }
}

class _SearchQuestionsBottomSheetContent
    extends State<SearchQuestionsBottomSheetContent> {
  TextEditingController _accountTypeController = TextEditingController();
  TextEditingController _mainCategoryController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();
  int accountTypeValue = -1;
  List<SearchModel> searchedList = List<SearchModel>();
  SearchQuestionBloc searchQuestionBloc;
  String categoryId, subCategoryId;
  List<SearchModel> selectedTagsItem = List<SearchModel>();
  Map<String, int> wrapTagItemsIndex = Map<String, int>();
  int orderByQuestions = -1;
  @override
  void initState() {
    super.initState();
    searchQuestionBloc = serviceLocator<SearchQuestionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchQuestionBloc>(
      create: (context) => searchQuestionBloc,
      child: BlocListener<SearchQuestionBloc, SearchQuestionState>(
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
          } else if (state is ResetAdvanceSearchValuesState) {
            _handleResetAdvanceSearchValuesState();
          } else if (state is ChanagSelectedTagListState) {
            _handleChanagSelectedTagListState(state);
          }
        },
        child: BlocBuilder<SearchQuestionBloc, SearchQuestionState>(
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
                            SizedBox(height: 10),
                            sortByIconWithText("Normal ordering",
                                "assets/images/sort_down.svg", () {
                              orderByQuestions = 0;
                              Navigator.of(context).pop(addParam());
                            }),
                            SizedBox(height: 10),
                            sortByIconWithText("Most useful question",
                                "assets/images/ic_useful_clicked.svg", () {
                              orderByQuestions = 1;
                              Navigator.of(context).pop(addParam());
                            }),
                            SizedBox(height: 10),
                            sortByIconWithText(
                                "No answer", "assets/images/speech_bubble.svg",
                                () {
                              orderByQuestions = 3;
                              Navigator.of(context).pop(addParam());
                            }),
                            SizedBox(height: 10),
                            sortByIconWithText("My answer and comments",
                                "assets/images/ic_useful_clicked.svg", () {
                              orderByQuestions = 4;
                              Navigator.of(context).pop(addParam());
                            }),
                            SizedBox(height: 10),
                            sortByIconWithText(
                                "Trends", "assets/images/ic_useful_clicked.svg",
                                () {
                              orderByQuestions = 2;
                              Navigator.of(context).pop(addParam());
                            }),
                            SizedBox(height: 10),
                            sortByIconWithText("My questions",
                                "assets/images/ic_useful_clicked.svg", () {
                              orderByQuestions = 5;
                              Navigator.of(context).pop(addParam());
                            }),
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
    orderByQuestions = -1;
  }

  Widget sortByIconWithText(String text, String svgPath, Function function) {
    return InkWell(
      onTap: function,
      child: Row(
        children: [
          SvgPictureView(svgPath: svgPath, height: 16, width: 16),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: lightMontserrat(
              fontSize: 14,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
          ),
        ],
      ),
    );
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
        searchQuestionBloc.add(ChanagSelectedTagListEvent(tagsItem: value));
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
                searchQuestionBloc.add(RemoveSelectedTagItem(
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
              searchQuestionBloc.add(ResetAdvanceSearchValues());
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
                    style: mediumMontserrat(
                      color: Colors.white,
                      fontSize: 12,
                    ),
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
      "orderByQuestions": orderByQuestions,
      "isAdvanceSearch": true
    };
    widget.searchBloc.add(ProviderAdvanceSearch());
    return param;
  }

  Widget addTagsButton(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          searchQuestionBloc.add(GetAdvanceSearchAllTags());
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
                ? 'Individual'
                : value == 1
                    ? 'Enterprise'
                    : 'Researcher';
          }
        });
      },
    );
  }

  Widget subCategoryDropdownButton(BuildContext context) {
    return DropDownTextField(
      hintText: 'Sub Category',
      controller: _subCategoryController,
      errorText: null,
      handleTap: () {
        if (categoryId == null || categoryId.length == 0)
          GlobalPurposeFunctions.showToast(
              AppLocalizations.of(context).please_select_category, context);
        else {
          searchQuestionBloc
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
        searchQuestionBloc.add(GetAdvanceSearchMainCategory());
      },
    );
  }
}
