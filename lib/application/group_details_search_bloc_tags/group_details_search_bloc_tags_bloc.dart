import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

part 'group_details_search_bloc_tags_event.dart';
part 'group_details_search_bloc_tags_state.dart';

class GroupDetailsSearchBlocTagsBloc extends Bloc<
    GroupDetailsSearchBlocTagsEvent, GroupDetailsSearchBlocTagsState> {
  GroupDetailsSearchBlocTagsBloc() : super(GroupDetailsSearchBlocTagsState());

  @override
  Stream<GroupDetailsSearchBlocTagsState> mapEventToState(
      GroupDetailsSearchBlocTagsEvent event) async* {
    if (event is ChangeSearchValueEvent)
      yield* _mapChangeSearchValueState(event, state);
    if (event is ChangeInitialItemValue)
      yield* _mapChangeInitialItemValue(event, state);
    else if (event is ChangeSelectedTagItemsEvent)
      yield* _mapChangeSelectedTagItemEvent(event, state);
  }

  Stream<GroupDetailsSearchBlocTagsState> _mapChangeSearchValueState(
      ChangeSearchValueEvent event,
      GroupDetailsSearchBlocTagsState state) async* {
    List<SearchModel> searchArrayList = new List<SearchModel>();
    searchArrayList = List.from(state.tagsList.where((element) =>
        element.name.toLowerCase().contains(event.searchValue.toLowerCase())));
    state = state.copyWith(searchedList: searchArrayList);
    yield state;
  }

  Stream<GroupDetailsSearchBlocTagsState> _mapChangeInitialItemValue(
      ChangeInitialItemValue event,
      GroupDetailsSearchBlocTagsState state) async* {
    state = state.copyWith(
        tagsList: event.newSearchArrayList,
        selectedBoolTagItems: event.tagSelectedItem,
        maxSelectedNumber: event.numberOfSelectedValue
        );
    yield state;
  }

  Stream<GroupDetailsSearchBlocTagsState> _mapChangeSelectedTagItemEvent(
      ChangeSelectedTagItemsEvent event,
      GroupDetailsSearchBlocTagsState state) async* {
    List<bool> items = List<bool>();
    items = state.selectedBoolTagItems;
    int number = state.maxSelectedNumber;
    if (!items[event.index]) {
      if (state.maxSelectedNumber < 5) {
        items[event.index] = !items[event.index];
        number++;
      } else {
        GlobalPurposeFunctions.showToast(AppLocalizations.of(event.context).you_have_exceeded_the_number_of_limited_entries, event.context);
      }
    } else {
      items[event.index] = !items[event.index];
      number--;
    }
    yield state.copyWith(
        maxSelectedNumber: number, selectedBoolTagItems: items);
  }
}
