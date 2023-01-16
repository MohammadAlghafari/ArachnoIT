import 'package:arachnoit/application/search/search_bloc.dart';
import 'package:arachnoit/application/search_group/search_group_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/dropdown_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/searchDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchGroupsBottomSheetContent extends StatefulWidget {
  final SearchBloc searchBloc;
  SearchGroupsBottomSheetContent({this.searchBloc});
  @override
  State<StatefulWidget> createState() {
    return _SearchGroupsBottomSheetContent();
  }
}

class _SearchGroupsBottomSheetContent
    extends State<SearchGroupsBottomSheetContent> {
  TextEditingController _mainCategoryController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();
  List<SearchModel> searchedList = List<SearchModel>();
  String categoryId = "";
  String subCategoryID = "";
  SearchGroupBloc searchGroupBloc;
  @override
  void initState() {
    super.initState();
    searchGroupBloc = serviceLocator<SearchGroupBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchGroupBloc>(
      create: (context) => searchGroupBloc,
      child: BlocListener<SearchGroupBloc, SearchGroupState>(
        listener: (context, state) {
          if (state is LoadingState) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          } else if (state is GetAdvanceSearchSubCategorySuccess) {
            _handleGetAdvanceSearchSubCategorySuccess(state);
          } else if (state is GetAdvanceSearchMainCategorySucces) {
            _handleGetAdvanceSearchMainCategorySucces(state);
          } else if (state is ResetAdvanceSearchValuesState) {
            _handleResetAdvanceSearchValuesState();
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            GlobalPurposeFunctions.showToast(
              AppLocalizations.of(context).check_your_internet_connection,
              context,
            );
          }
        },
        child: SingleChildScrollView(
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
                          AppLocalizations
                              .of(context)
                              .advanced,
                          style: regularMontserrat(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 10),
                        mainCategory(context),
                        SizedBox(height: 10),
                        subCategories(context),
                        SizedBox(height: 10),
                        resetAndSearchButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleResetAdvanceSearchValuesState() {
    _mainCategoryController.text = "";
    _subCategoryController.text = "";
    categoryId = "";
    subCategoryID = "";
  }

  void _handleGetAdvanceSearchMainCategorySucces(
      GetAdvanceSearchMainCategorySucces state) {
    GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
        .then((value) {
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
    });
  }

  void _handleGetAdvanceSearchSubCategorySuccess(
      GetAdvanceSearchSubCategorySuccess state) {
    GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
        .then((value) {
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
          subCategoryID = state.subCategories[val].id;
          _subCategoryController.text = state.subCategories[val].name;
        }
      });
    });
  }

  Widget resetAndSearchButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: FlatButton(
            onPressed: () {
              searchGroupBloc.add(ResetAdvanceSearchValues());
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
                    AppLocalizations.of(context).reset,
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
              Map<String, dynamic> param = Map<String, dynamic>();
              widget.searchBloc.add(ProviderAdvanceSearch());
              param = {
                'categoryID': categoryId,
                'subCategoryID': subCategoryID,
                'isAdvanceSearch': true,
                "searchText": ''
              };
              Navigator.of(context).pop(param);
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
                    AppLocalizations.of(context).search,
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

  Widget subCategories(BuildContext context) {
    return DropDownTextField(
      hintText: AppLocalizations.of(context).subCategory,
      controller: _subCategoryController,
      errorText: null,
      handleTap: () {
        _mainCategoryController.text.isEmpty
            ? GlobalPurposeFunctions.showToast(
                AppLocalizations.of(context).please_select_category,
                context,
              )
            : searchGroupBloc.add(GetAdvanceSearchSubCategory(
                categoryId: categoryId,
              ));
      },
    );
  }

  Widget mainCategory(BuildContext context) {
    return DropDownTextField(
      hintText: AppLocalizations.of(context).main_category,
      controller: _mainCategoryController,
      errorText: null,
      handleTap: () {
        searchGroupBloc.add(GetAdvanceSearchMainCategory());
      },
    );
  }
}
