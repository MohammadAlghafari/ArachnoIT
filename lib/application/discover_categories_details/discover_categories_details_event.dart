part of 'discover_categories_details_bloc.dart';

abstract class DiscoverCategoriesDetailsEvent extends Equatable {
  const DiscoverCategoriesDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchSubCategoryDataEvent extends DiscoverCategoriesDetailsEvent {
  FetchSubCategoryDataEvent(
      {this.selectedItemIndex,
      this.categoryId,
      this.subCategoryId,
      this.blogsCount,
      this.questionsCount,
      this.groupsCount,
     @required this.context
      });
  final int selectedItemIndex;
  final String categoryId;
  final String subCategoryId;
  final int blogsCount;
  final int questionsCount;
  final int groupsCount;
  final BuildContext context;

  @override
  List<Object> get props => [selectedItemIndex];
}
