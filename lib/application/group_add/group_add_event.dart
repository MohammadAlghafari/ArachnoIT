part of 'group_add_bloc.dart';

abstract class GroupAddEvent extends Equatable {
  const GroupAddEvent();

  @override
  List<Object> get props => [];
}

class ChangeRadioButtonIndex extends GroupAddEvent{
  final GroupType selectedRadioButtonGroupType;
  ChangeRadioButtonIndex({@required this.selectedRadioButtonGroupType});
}

class AddGroupNameChange extends GroupAddEvent {
  final String name;
  AddGroupNameChange({@required this.name});
}

class AddGroupDescriptionChange extends GroupAddEvent {
  final String description;
  AddGroupDescriptionChange({@required this.description});
}





class AddGroupCategoryDropDownChange extends GroupAddEvent {
  final String categoryDropDown;
  AddGroupCategoryDropDownChange({@required this.categoryDropDown});
}

class CheckSubCategories extends GroupAddEvent{
 final List<SubCategoryModel> subcategory;
 final SubCategoryModel index;

 const CheckSubCategories({@required this.subcategory,@required this.index});
}

class SpiltSubCategoryChecked extends GroupAddEvent{
  final List<SubCategoryModel> subcategory;
  final List<SubCategoryModel>  currentSubCategory;
  const SpiltSubCategoryChecked({@required this.subcategory,@required this.currentSubCategory});
}

class GetCategoryGroup extends GroupAddEvent{

}


class SetDetailsGroup extends GroupAddEvent{
  final GroupDetailsResponse groupDetailsResponse;
  final List<GroupSubCategoryResponse> subCategories;
  final int groupPrivacy;
  const SetDetailsGroup({
    @required this.groupDetailsResponse,
    @required this.subCategories,@required this.groupPrivacy});
}

class RefreshScreen extends GroupAddEvent{
  const RefreshScreen();
}


class RemoveSubCategory extends GroupAddEvent{
final SubCategoryModel subCategoryDeleted;
final List<SubCategoryModel> subCategories;

const RemoveSubCategory({@required this.subCategoryDeleted,@required this.subCategories});
}

class GetSubCategoryGroup extends GroupAddEvent{
  final List<SubCategoryModel> currentSubCategory;
final String categoryId;
const GetSubCategoryGroup({@required this.categoryId,@required this.currentSubCategory});

}

class GetAllGroup extends GroupAddEvent{
  final String healthcareProviderId;
  final String groupId;
  const GetAllGroup({@required this.healthcareProviderId,@required this.groupId});
}


class SearchQuerySubCategory extends GroupAddEvent{
  final List<SubCategoryModel> searchList;
  final String query;


  const SearchQuerySubCategory({@required this.searchList,@required this.query});
}






class SubmittedButtonAddGroup extends GroupAddEvent{
  final String id;
  final String description;
  final String name;
  final String parentGroupId;
  final List<SubCategoryModel> subCategory;
  final GroupType privacyLevel;
  final File file;
  const SubmittedButtonAddGroup({
    @required this.name,
    @required this.id,
    @required this.description,
    @required this.parentGroupId,
    @required this.subCategory,
    @required this.privacyLevel,
    @required this.file,
});


}


class AddGroupCategoryValidation extends GroupAddEvent {
  final String categoryDropDown;
  AddGroupCategoryValidation({
    @required this.categoryDropDown,
  });
}

class AddGroupSubCategoryValidation extends GroupAddEvent {
  final String subCategoryDropDown;
  AddGroupSubCategoryValidation({
    @required this.subCategoryDropDown,
  });
}

class AddGroupSaveGroupCheckValidation extends GroupAddEvent {
  final String description;
  final String name;
  final String categoryDropDown;
  final String subCategoryDropDown;
  final String mainGroupDropDown;
  AddGroupSaveGroupCheckValidation({
    @required this.description,
    @required this.name,
    @required this.categoryDropDown,
    @required this.mainGroupDropDown,
    @required this.subCategoryDropDown,
  });
}
