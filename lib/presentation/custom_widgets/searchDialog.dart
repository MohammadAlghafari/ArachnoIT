import 'dart:ui';

import 'package:arachnoit/common/font_style.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../infrastructure/api/search_model.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({Key key, this.data}) : super(key: key);
  final List<SearchModel> data;

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  List<SearchModel> searchedList = [];
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      child: Container(
          height: 400,
          child: FloatingSearchBar(
            hint: AppLocalizations
                .of(context)
                .search + '.....',
            hintStyle: mediumMontserrat(
              fontSize: 18,
              color: Colors.black54,
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
              setState(() {
                searchedList = List.from(widget.data.where((element) =>
                    element.name.toLowerCase().contains(query.toLowerCase())));
              });
            },
            // Specify a custom transition to be used for
            // animating between opened and closed stated.
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
                      Navigator.of(context).pop(widget.data.indexWhere(
                          (element) => element.id == searchedList[i].id));
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
                                  color: Colors.black87,
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
            body: Container(
              padding: EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(i);
                    },
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: AutoDirection(
                            text: widget.data[i].name,
                            child: Text(
                              widget.data[i].name,
                              style: lightMontserrat(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: widget.data.length,
                shrinkWrap: true,
              ),
            ),
            elevation: 0.5,
            automaticallyImplyBackButton: false,
            automaticallyImplyDrawerHamburger: false,
            isScrollControlled: true,
          )),
    );
  }
}
