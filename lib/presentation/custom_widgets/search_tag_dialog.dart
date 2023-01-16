import 'dart:ui';
import 'package:arachnoit/application/group_details_search_bloc_tags/group_details_search_bloc_tags_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/injections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../../infrastructure/api/search_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchTagDialog extends StatefulWidget {
  const SearchTagDialog(
      {Key key, @required this.data, @required this.wrapIdTagsItem})
      : super(key: key);
  final List<SearchModel> data;
  final Map<String, int> wrapIdTagsItem;
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchTagDialog> {
  GroupDetailsSearchBlocTagsBloc groupDetailsSearchBlocTagsBloc;
  List<SearchModel> searchedList = List<SearchModel>();
  List<bool> isSelectedItem = List<bool>();
  int numberOfSelectedItem;
  FloatingSearchBarController controller;
  @override
  void initState() {
    super.initState();
    groupDetailsSearchBlocTagsBloc =
        serviceLocator<GroupDetailsSearchBlocTagsBloc>();
    for (int i = 0; i < widget.data.length; i++) isSelectedItem.add(false);
    for (var mapValue in widget.wrapIdTagsItem.entries) {
      isSelectedItem[mapValue.value] = true;
    }
    groupDetailsSearchBlocTagsBloc.add(ChangeInitialItemValue(
        newSearchArrayList: widget.data,
        tagSelectedItem: isSelectedItem,
        numberOfSelectedValue: widget.wrapIdTagsItem.entries.length));
    controller = FloatingSearchBarController();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return BlocProvider<GroupDetailsSearchBlocTagsBloc>(
      create: (context) => groupDetailsSearchBlocTagsBloc,
      child: BlocListener<GroupDetailsSearchBlocTagsBloc,
          GroupDetailsSearchBlocTagsState>(
        listener: (context, state) {
          if (state is GroupDetailsSearchBlocTagsState) {
            searchedList = state.searchedList;
            isSelectedItem = state.selectedBoolTagItems;
          }
        },
        child: BlocBuilder<GroupDetailsSearchBlocTagsBloc,
            GroupDetailsSearchBlocTagsState>(
          builder: (context, state) {
            return Dialog(
              child: Container(
                height: 400,
                child: FloatingSearchBar(
                  controller: controller,
                  hint: AppLocalizations
                      .of(context)
                      .search + '...',
                  hintStyle: mediumMontserrat(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  scrollPadding: const EdgeInsets.only(top: 0, bottom: 5),
                  transitionDuration: const Duration(milliseconds: 0),
                  margins: EdgeInsets.all(5),
                  transitionCurve: Curves.easeInOut,
                  physics: const BouncingScrollPhysics(),
                  axisAlignment: isPortrait ? 0.0 : -1.0,
                  openAxisAlignment: 0.0,
                  maxWidth: isPortrait ? 600 : 500,
                  debounceDelay: const Duration(milliseconds: 0),
                  onQueryChanged: (query) {
                    groupDetailsSearchBlocTagsBloc
                        .add(ChangeSearchValueEvent(searchValue: query));
                  },
                  transition: CircularFloatingSearchBarTransition(),
                  actions: [
                    FloatingSearchBarAction.searchToClear(
                      showIfClosed: false,
                    ),
                  ],
                  leadingActions: [FloatingSearchBarAction.back()],
                  builder: (context, transition) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ListView.builder(
                        itemBuilder: (context, i) => GestureDetector(
                          onTap: () {
                            int index = 0;
                            for (index = 0; index < widget.data.length; index++)
                              if (widget.data[index].id == searchedList[i].id)
                                break;
                            groupDetailsSearchBlocTagsBloc.add(
                                ChangeSelectedTagItemsEvent(
                                    index: index, context: context));
                            controller.close();
                          },
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Icon(Icons.search)),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 4,
                                    child: Text(
                                      searchedList[i].name,
                                      style: lightMontserrat(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        itemCount: searchedList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    );
                  },
                  body: Stack(
                    children: [
                      showBody(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    List<SearchModel> item =
                                    List<SearchModel>();
                                    for (int i = 0;
                                    i < widget.data.length;
                                    i++) {
                                      if (state.selectedBoolTagItems[i])
                                        item.add(SearchModel(
                                            id: widget.data[i].id,
                                            name: widget.data[i].name));
                                    }
                                    Navigator.of(context).pop(item);
                                  },
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        AppLocalizations.of(context).submit,
                                        style: mediumMontserrat(
                                            fontSize: 14,
                                            color:
                                            Theme
                                                .of(context)
                                                .accentColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        AppLocalizations.of(context).cancel,
                                        style: mediumMontserrat(
                                            fontSize: 14,
                                            color:
                                            Theme
                                                .of(context)
                                                .accentColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  elevation: 0.5,
                  automaticallyImplyBackButton: false,
                  automaticallyImplyDrawerHamburger: false,
                  isScrollControlled: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget showBody() {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 50),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                groupDetailsSearchBlocTagsBloc.add(
                    ChangeSelectedTagItemsEvent(index: i, context: context));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      widget.data[i].name,
                      style: lightMontserrat(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    child: Checkbox(
                      value: isSelectedItem[i],
                      onChanged: (value) {
                        groupDetailsSearchBlocTagsBloc.add(
                            ChangeSelectedTagItemsEvent(
                                index: i, context: context));
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: widget.data.length,
        shrinkWrap: true,
      ),
    );
  }
}
