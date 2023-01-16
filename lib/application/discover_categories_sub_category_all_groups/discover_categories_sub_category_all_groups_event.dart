part of 'discover_categories_sub_category_all_groups_bloc.dart';

abstract class DiscoverCategoriesSubCategoryAllGroupsEvent extends Equatable {
  const DiscoverCategoriesSubCategoryAllGroupsEvent();

  @override
  List<Object> get props => [];
}

class SubCategoryGroupsFetchEvent extends DiscoverCategoriesSubCategoryAllGroupsEvent {
  SubCategoryGroupsFetchEvent({
    this.subCategoryId,
    this.isReloadData=false
  });
  
  final String subCategoryId;
  final bool isReloadData;
  @override
  List<Object> get props => [subCategoryId,isReloadData];
}
