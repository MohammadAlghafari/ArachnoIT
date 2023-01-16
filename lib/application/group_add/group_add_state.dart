part of 'group_add_bloc.dart';

enum GroupType { Public, Closed, Private, Encoded }

@immutable
class GroupAddState {
  final RequestState addGroupState;
  final FormzStatus status;
  final List<SearchModel> groupCategory;
  final List<SearchModel> groups;
  final bool helpRefresh;
  final RequestState stateAllGroup;
  final RequestState stateCategory;
  final RequestState stateSubCategory;
  final GroupAddState addGroupStatus;
  final String newGroupId;
  final AddGroupResponse addGroupResponse;
  final List<SubCategoryModel> groupSubCategory;
  final List<SubCategoryModel> searchSubCategory;
  final List<SubCategoryModel> groupSubCategorySelected;
  final AddGroupName addGroupName;
  final AddGroupDescription addGroupDescription;
  final AddGroupCategoryBottomSheet addGroupCategoryDropDown;
  final AddGroupSubCategoryDropDown addGroupSubCategoryDropDown;
  final AddGroupMainGroupDropDown addGroupMainGroupDropDown;
  final GroupType selectedRadioButtonGroupType;

  const GroupAddState({
    this.status = FormzStatus.pure,
    this.addGroupResponse ,
    this.helpRefresh = false,
    this.searchSubCategory = const <SubCategoryModel>[],
    this.groupSubCategorySelected = const <SubCategoryModel>[],
    this.addGroupStatus,
    this.stateAllGroup = RequestState.initial,
    this.newGroupId = '',
    this.stateCategory = RequestState.initial,
    this.stateSubCategory = RequestState.initial,
    this.addGroupState = RequestState.initial,
    this.groups = const <SearchModel>[],
    this.groupCategory = const <SearchModel>[],
    this.groupSubCategory = const <SubCategoryModel>[],
    this.addGroupDescription = const AddGroupDescription.pure(),
    this.addGroupName = const AddGroupName.pure(),
    this.addGroupCategoryDropDown = const AddGroupCategoryBottomSheet.pure(),
    this.addGroupSubCategoryDropDown = const AddGroupSubCategoryDropDown.pure(),
    this.addGroupMainGroupDropDown = const AddGroupMainGroupDropDown.pure(),
    this.selectedRadioButtonGroupType = GroupType.Public,
  });

  copyWith({
    FormzStatus status,
    AddGroupName addGroupName,
    AddGroupResponse addGroupResponse,
    bool helpRefresh,
    String newGroupId,
    RequestState addGroupState,
    RequestState stateAllGroup,
    RequestState stateCategory,
    RequestState stateSubCategory,
    List<SubCategoryModel> searchSubCategory,
    List<SubCategoryModel> groupSubCategorySelected,
    GroupAddState addGroupStatus,
    List<SearchModel> groups,
    List<SearchModel> groupCategory,
    List<SubCategoryModel> groupSubCategoryChecked,
    AddGroupDescription addGroupDescription,
    AddGroupCategoryBottomSheet addGroupCategoryBottomSheet,
    AddGroupSubCategoryDropDown addGroupSubCategoryDropDown,
    AddGroupMainGroupDropDown addGroupMainGroupDropDown,
    GroupType selectedRadioButtonGroupType,
  }) {
    return GroupAddState(
      status: (status) ?? this.status,
      addGroupResponse: (addGroupResponse) ?? this.addGroupResponse,
      newGroupId: (newGroupId) ?? this.newGroupId,
      helpRefresh: (helpRefresh) ?? this.helpRefresh,
      searchSubCategory: (searchSubCategory) ?? this.searchSubCategory,
      stateCategory: (stateCategory) ?? this.stateCategory,
      stateSubCategory: (stateSubCategory) ?? this.stateSubCategory,
      addGroupStatus: (addGroupStatus) ?? this.addGroupStatus,
      stateAllGroup: (stateAllGroup) ?? this.stateAllGroup,
      groupSubCategorySelected: (groupSubCategorySelected) ?? this.groupSubCategorySelected,
      groups: (groups) ?? this.groups,
      addGroupState: (addGroupState) ?? this.addGroupState,
      addGroupName: (addGroupName) ?? this.addGroupName,
      addGroupDescription: (addGroupDescription) ?? this.addGroupDescription,
      addGroupCategoryDropDown: (addGroupCategoryBottomSheet) ?? this.addGroupCategoryDropDown,
      addGroupSubCategoryDropDown: (addGroupSubCategoryDropDown) ?? this.addGroupSubCategoryDropDown,
      addGroupMainGroupDropDown: (addGroupMainGroupDropDown) ?? this.addGroupMainGroupDropDown,
      selectedRadioButtonGroupType: (selectedRadioButtonGroupType) ?? this.selectedRadioButtonGroupType,
      groupCategory: (groupCategory) ?? this.groupCategory,
      groupSubCategory: (groupSubCategoryChecked) ?? this.groupSubCategory,
    );
  }
}

class LoadingState extends GroupAddState {}

class GetCategorySuccess extends GroupAddState {
  final List<SearchModel> groupCategory;

  const GetCategorySuccess({@required this.groupCategory});
}

class ChangedGroupPrivacy extends GroupAddState {
  final GroupType groupType;

  const ChangedGroupPrivacy({@required this.groupType});
}

class GetSubCategorySuccess extends GroupAddState {
  final List<SubCategoryModel> groupSubCategories;

  const GetSubCategorySuccess({@required this.groupSubCategories});
}

class RefreshSubcategories extends GroupAddState {
  final List<SubCategoryModel> subCategories;

  const RefreshSubcategories({@required this.subCategories});
}

class GetAllGroupSuccess extends GroupAddState {
  final List<SearchModel> allGroup;

  const GetAllGroupSuccess({@required this.allGroup});
}

class RemoteValidationErrorState extends GroupAddState {
// RemoteValidationErrorState({this.remoteValidationErrorMessage});

// final String remoteValidationErrorMessage;
  @override
  List<Object> get props => [];
}

class RemoteServerErrorState extends GroupAddState {
// RemoteServerErrorState({this.remoteServerErrorMessage});

// final String remoteServerErrorMessage;
  @override
  List<Object> get props => [];
}

class RemoteClientErrorState extends GroupAddState {
  // RemoteClientErrorState({this.remoteClientErrorMessage});
//
  // final String remoteClientErrorMessage;
  @override
  List<Object> get props => [];
}
