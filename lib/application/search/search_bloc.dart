import 'dart:async';

import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/search_provider/response/advance_search_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CatalogFacadeService catalogService;
  SearchBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(SearchState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is ChangeSearchScreenEvent) {
      print("insider this ChangeSearchScreenEvent");
      yield state.copyWith(index: event.currentIndex);
    } else if (event is ProviderAdvanceSearch) {
      print("insider this ProviderAdvanceSearch");
      yield state.copyWith(
          shouldDestroyWidget: false,
          shouldReplaceState: !state.shouldReplaceState);
    } else if (event is SearchFromTextEvent) {
      print("insider this SearchFromTextEvent");
      yield state.copyWith(
          shouldDestroyWidget: true,
          shouldReplaceState: !state.shouldReplaceState);
    }
  }
}
