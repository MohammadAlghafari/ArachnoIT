import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class CommonLanguage {
  static List<String> _items;
  CommonLanguage(BuildContext context) {
    _items = [
      AppLocalizations.of(context).native,
      AppLocalizations.of(context).beginner,
      AppLocalizations.of(context).elementary,
      AppLocalizations.of(context).intermediate,
      AppLocalizations.of(context).upper_intermediate,
      AppLocalizations.of(context).advanced,
      AppLocalizations.of(context).professional
    ];
  }
   List<SearchModel> getLanguageLevelAsSearchModel() {
    List<SearchModel> searchModel = [];

    for (int i = 0; i < _items.length; i++) {
      searchModel.add(SearchModel(id: i.toString(), name: _items[i]));
    }
    return searchModel;
  }

   String getLevelNameByID(int id) {
    return _items[id];
  }
}
