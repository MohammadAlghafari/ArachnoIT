import 'dart:async';
import 'dart:io';
import 'package:arachnoit/infrastructure/api/response_type.dart' as ResType;

import 'package:arachnoit/domain/add_group/add_group_category_drop_down.dart';
import 'package:arachnoit/domain/add_group/add_group_description.dart';
import 'package:arachnoit/domain/add_group/add_group_main_group_drop_down.dart';
import 'package:arachnoit/domain/add_group/add_group_name.dart';
import 'package:arachnoit/domain/add_group/add_group_sub_category_drop_down.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/common_response/group_sub_category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:arachnoit/infrastructure/group_add/models/add_group_resposne.dart';
import 'package:arachnoit/infrastructure/group_add/models/group_category_response.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_details_response.dart';
import 'package:arachnoit/presentation/screens/group_add/group_add_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

part 'group_add_event.dart';

part 'group_add_state.dart';

class GroupAddBloc extends Bloc<GroupAddEvent, GroupAddState> {
  CatalogFacadeService catalogService;

  GroupAddBloc({this.catalogService})
      : assert(catalogService != null),
        super(GroupAddState());

  @override
  Stream<GroupAddState> mapEventToState(GroupAddEvent event) async* {
    if (event is AddGroupNameChange) {
      yield await _mapAddGroupNameOrDescriptionChange(event, state);
    } else if (event is AddGroupDescriptionChange) {
      yield await _mapAddGroupDescriptionChange(event, state);
    } else if (event is AddGroupSaveGroupCheckValidation) {
      yield await _mapAddGroupSaveGroupCheckValidation(event, state);
    } else if (event is GetCategoryGroup)
      yield* getGroupCategory(state);
    else if (event is GetSubCategoryGroup)
      yield* getGroupSubCategory(event, state);
    else if (event is GetAllGroup) yield* getAllGroup(state, event);
    if (event is ChangeRadioButtonIndex) {
      yield* _mapChangeRadioButtonIndex(event, state);
    } else if (event is SubmittedButtonAddGroup)
      yield* eventAddGroup(event, state);
    else if (event is CheckSubCategories)
      yield* eventCheckedCategories(event, state);
    else if (event is SpiltSubCategoryChecked)
      yield* eventSpiltCheckedCategories(event, state);
    else if (event is RemoveSubCategory)
      yield* eventRemoveCategories(event, state);
    else if (event is SearchQuerySubCategory)
      yield* eventSearchSubCategory(event, state);
    else if (event is SetDetailsGroup)
      yield* eventUpdateDetails(event, state);
    else if (event is RefreshScreen) {
      yield state.copyWith(helpRefresh: !state.helpRefresh);
    } else if (event is AddGroupCategoryValidation)
      yield await _mapAddGroupCategoryChange(event, state);
    else if (event is AddGroupSubCategoryValidation) yield await _mapAddGroupSubCategoryChange(event, state);
  }

  Stream<GroupAddState> eventUpdateDetails(SetDetailsGroup event, GroupAddState state) async* {
    List<SubCategoryModel> subCategoryModel = new List<SubCategoryModel>();
    for (int i = 0; i < event.subCategories.length; i++)
      subCategoryModel.add(SubCategoryModel(name: event.subCategories[i].name, id: event.subCategories[i].id, selected: true));
    yield state.copyWith(
        selectedRadioButtonGroupType: updateTypeLevelGroup(event.groupPrivacy),
        groupSubCategorySelected: subCategoryModel,
        addGroupSubCategoryDropDown: AddGroupSubCategoryDropDown.dirty((event.subCategories.length > 0) ? event.subCategories.last.name : null),
        addGroupMainGroupDropDown: AddGroupMainGroupDropDown.dirty(event.groupDetailsResponse.parentGroup.name));
  }

  Stream<GroupAddState> eventSearchSubCategory(SearchQuerySubCategory event, GroupAddState state) async* {
    //  yield
    List<SubCategoryModel> list = List.from(event.searchList.where((element) => element.name.toLowerCase().contains(event.query.toLowerCase())));
    yield state.copyWith(searchSubCategory: list);
  }

  Stream<GroupAddState> eventSpiltCheckedCategories(SpiltSubCategoryChecked event, GroupAddState state) async* {
    event.subcategory.removeWhere((element) => element.selected == false);
    // if(event.currentSubCategory.length>0)
    //   for(int i=0;i<event.subcategory.length;i++){
    //     print(event.subcategory[i].name);
    //     event.subcategory.removeWhere((element) => element.id==event.currentSubCategory[i].id);
    //  }

    yield state.copyWith(groupSubCategorySelected: List.of(event.currentSubCategory)..addAll(event.subcategory));
  }

  Stream<GroupAddState> eventCheckedCategories(CheckSubCategories event, GroupAddState state) async* {
    event.subcategory[event.subcategory.indexWhere((element) => element.id == event.index.id)] =
        SubCategoryModel(name: event.index.name, id: event.index.id, selected: !event.index.selected);
    yield state.copyWith(groupSubCategoryChecked: event.subcategory);
  }

  Stream<GroupAddState> eventRemoveCategories(RemoveSubCategory event, GroupAddState state) async* {
    event.subCategories.removeWhere((element) => element.id == event.subCategoryDeleted.id);

    yield state.copyWith(
      groupSubCategorySelected: event.subCategories,
    );
  }

  Stream<GroupAddState> eventAddGroup(SubmittedButtonAddGroup event, GroupAddState state) async* {
    yield state.copyWith(addGroupState: ResType.RequestState.loadingData);
    int privacyLevel = getTypeLevelGroup(event.privacyLevel);
    List<String> multiSubCategory = new List<String>();
    for (int i = 0; i < event.subCategory.length; i++) multiSubCategory.add(event.subCategory[i].id);
    final ResponseWrapper<AddGroupResponse> response = await catalogService.addGroup(
        id: event.id,
        subCategory: multiSubCategory,
        privacyLevel: privacyLevel,
        parentGroupId: event.parentGroupId,
        file: event.file,
        description: event.description,
        name: event.name);
    try {
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield state.copyWith(addGroupState: ResType.RequestState.success, addGroupResponse: response.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(addGroupStatus: RemoteValidationErrorState());
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(addGroupStatus: RemoteServerErrorState());
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
      }
    } catch (e) {
      print('RemoteClientErrorState');
      yield state.copyWith(addGroupStatus: RemoteClientErrorState());
    }
    yield state.copyWith(
      addGroupState: ResType.RequestState.initial,
    );
  }

  GroupType updateTypeLevelGroup(int groupType) {
    switch (groupType) {
      case 0:
        return GroupType.Public;
        break;
      case 1:
        return GroupType.Closed;
        break;
      case 2:
        return GroupType.Private;
        break;
      case 3:
        return GroupType.Encoded;
        break;
    }
  }

  int getTypeLevelGroup(GroupType groupType) {
    switch (groupType) {
      case GroupType.Public:
        return 0;
        break;
      case GroupType.Closed:
        return 1;
        break;
      case GroupType.Private:
        return 2;
        break;
      case GroupType.Encoded:
        return 3;
        break;
    }
  }

  Stream<GroupAddState> getAllGroup(GroupAddState state, GetAllGroup event) async* {
    yield state.copyWith(addGroupStatus: LoadingState());
    final ResponseWrapper<List<GroupResponse>> response = await catalogService.getAllGroup(healthcareProviderId: event.healthcareProviderId);
    try {
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          List<SearchModel> groups = new List<SearchModel>();
          if (response.data.length > 0) {
            if (event.groupId != null) {
              for (int i = 0; i < response.data.length; i++) {
                if (event.groupId != response.data[i].id && event.healthcareProviderId== response.data[i].ownerId)
                  groups.add(SearchModel(id: response.data[i].id, name: response.data[i].name));
              }
            } else {
              for (int i = 0; i < response.data.length; i++) {
                if(event.healthcareProviderId== response.data[i].ownerId)
                groups.add(SearchModel(id: response.data[i].id, name: response.data[i].name));
              }
            }
          }

          yield state.copyWith(stateAllGroup: RequestState.success, groups: groups);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(addGroupStatus: RemoteValidationErrorState());
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(addGroupStatus: RemoteServerErrorState());
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
      }
    } catch (e) {
      yield state.copyWith(addGroupStatus: RemoteClientErrorState());
    }
    yield state.copyWith(
      stateAllGroup: ResType.RequestState.initial,
    );
  }

  Stream<GroupAddState> getGroupCategory(GroupAddState state) async* {
    yield state.copyWith(addGroupStatus: LoadingState());
    final ResponseWrapper<List<CategoryAndSubResponse>> response = await catalogService.getGroupCategory();
    try {
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          List<SearchModel> groupCategory = new List<SearchModel>();
          if (response.data.length > 0)
            for (int i = 0; i < response.data.length; i++) groupCategory.add(SearchModel(id: response.data[i].id, name: response.data[i].name));
          yield state.copyWith(groupCategory: groupCategory, stateCategory: ResType.RequestState.success);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(addGroupStatus: RemoteValidationErrorState());
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(addGroupStatus: RemoteServerErrorState());
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
      }
    } catch (e) {
      yield state.copyWith(addGroupStatus: RemoteClientErrorState());
    }
    yield state.copyWith(stateCategory: ResType.RequestState.initial);
  }

  Stream<GroupAddState> getGroupSubCategory(GetSubCategoryGroup event, GroupAddState state) async* {
    yield state.copyWith(addGroupStatus: LoadingState());
    final ResponseWrapper<List<SubCategoryResponse>> response = await catalogService.getGroupSubCategory(categoryId: event.categoryId);
    try {
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          print(event.currentSubCategory.length);
          List<SubCategoryModel> groupSubCategory = new List<SubCategoryModel>();
          if (response.data.length > 0)
            for (int i = 0; i < response.data.length; i++) {
              bool found = false;
              event.currentSubCategory.forEach((element) {
                if (response.data[i].id == element.id) found = true;
              });
              if (!found) groupSubCategory.add(SubCategoryModel(id: response.data[i].id, name: response.data[i].name, selected: false));
            }
          yield state.copyWith(groupSubCategoryChecked: groupSubCategory, stateSubCategory: ResType.RequestState.success);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield state.copyWith(addGroupStatus: RemoteValidationErrorState());
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield state.copyWith(addGroupStatus: RemoteServerErrorState());
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield state.copyWith(addGroupStatus: RemoteClientErrorState());
          break;
      }
    } catch (e) {
      yield state.copyWith(addGroupStatus: RemoteClientErrorState());
    }
    yield state.copyWith(stateSubCategory: ResType.RequestState.initial);
  }

  Stream<GroupAddState> _mapChangeRadioButtonIndex(ChangeRadioButtonIndex event, GroupAddState state) async* {
    yield state.copyWith(selectedRadioButtonGroupType: event.selectedRadioButtonGroupType);
  }

  Future<GroupAddState> _mapAddGroupDescriptionChange(AddGroupDescriptionChange event, GroupAddState state) async {
    final addGroupDescription = AddGroupDescription.dirty(event.description);
    state = state.copyWith(addGroupDescription: addGroupDescription, status: Formz.validate([addGroupDescription]));
    return state;
  }

  Future<GroupAddState> _mapAddGroupNameOrDescriptionChange(AddGroupNameChange event, GroupAddState state) async {
    final addGroupName = AddGroupName.dirty(event.name);
    state = state.copyWith(addGroupName: addGroupName, status: Formz.validate([addGroupName]));
    return state;
  }

  Future<GroupAddState> _mapAddGroupCategoryChange(AddGroupCategoryValidation event, GroupAddState state) async {
    final addGroupCategory = AddGroupCategoryBottomSheet.dirty(event.categoryDropDown);
    state = state.copyWith(addGroupCategoryBottomSheet: addGroupCategory, status: Formz.validate([addGroupCategory]));
    return state;
  }

  Future<GroupAddState> _mapAddGroupSubCategoryChange(AddGroupSubCategoryValidation event, GroupAddState state) async {
    print('click');
    final addGroupSubCategory = AddGroupSubCategoryDropDown.dirty(event.subCategoryDropDown);
    state = state.copyWith(addGroupSubCategoryDropDown: addGroupSubCategory, status: Formz.validate([addGroupSubCategory]));
    return state;
  }

  Future<GroupAddState> _mapAddGroupSaveGroupCheckValidation(AddGroupSaveGroupCheckValidation event, GroupAddState state) async {
    final addGroupName = AddGroupName.dirty(event.name);
    final addGroupDescription = AddGroupDescription.dirty(event.description);
    final addGroupCategoryDropDown = AddGroupCategoryBottomSheet.dirty(event.categoryDropDown);
    final addGroupSubCategoryDropDown = AddGroupSubCategoryDropDown.dirty(event.subCategoryDropDown);
    final addGroupMainGroupDropDown = AddGroupMainGroupDropDown.dirty(event.mainGroupDropDown);
    print('addGroupSubCategoryDropDown is $addGroupSubCategoryDropDown');
    state = state.copyWith(
        addGroupName: addGroupName,
        status: Formz.validate([
          addGroupName,
          state.addGroupDescription,
          state.addGroupCategoryDropDown,
          state.addGroupSubCategoryDropDown,
          state.addGroupMainGroupDropDown,
        ]));
    if (state.addGroupName.invalid) return state;
    state = state.copyWith(
        addGroupDescription: addGroupDescription,
        status: Formz.validate([
          state.addGroupName,
          addGroupDescription,
          state.addGroupCategoryDropDown,
          state.addGroupSubCategoryDropDown,
          state.addGroupMainGroupDropDown,
        ]));
    if (state.addGroupDescription.invalid) return state;
    state = state.copyWith(
        addGroupCategoryBottomSheet: addGroupCategoryDropDown,
        status: Formz.validate([
          state.addGroupName,
          state.addGroupDescription,
          addGroupCategoryDropDown,
          state.addGroupSubCategoryDropDown,
          state.addGroupMainGroupDropDown,
        ]));
    if (state.addGroupCategoryDropDown.invalid) return state;
    state = state.copyWith(
        addGroupSubCategoryDropDown: addGroupSubCategoryDropDown,
        status: Formz.validate([
          state.addGroupName,
          state.addGroupDescription,
          state.addGroupCategoryDropDown,
          addGroupSubCategoryDropDown,
          state.addGroupMainGroupDropDown,
        ]));
    if (state.addGroupSubCategoryDropDown.invalid) return state;
    state = state.copyWith(
        addGroupMainGroupDropDown: addGroupMainGroupDropDown,
        status: Formz.validate([
          state.addGroupName,
          state.addGroupDescription,
          state.addGroupCategoryDropDown,
          state.addGroupSubCategoryDropDown,
          addGroupMainGroupDropDown,
        ]));
    if (state.addGroupMainGroupDropDown.invalid) return state;
    return state;
  }
}
