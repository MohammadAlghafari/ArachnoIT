part of 'discover_categories_sub_category_all_questions_bloc.dart';

abstract class DiscoverCategoriesSubCategoryAllQuestionsEvent extends Equatable {
  const DiscoverCategoriesSubCategoryAllQuestionsEvent();

  @override
  List<Object> get props => [];
}

class SubCategoryAllQuestionsFetchEvent extends DiscoverCategoriesSubCategoryAllQuestionsEvent {
  SubCategoryAllQuestionsFetchEvent({
    this.subCategoryId,
    this.isUpdateData=false,
  });
  final String subCategoryId;
  final bool isUpdateData;
   @override
  List<Object> get props => [subCategoryId];
}

class DeleteQuestion extends DiscoverCategoriesSubCategoryAllQuestionsEvent {
  final String questionId;
  final int index;
  final BuildContext context;
  DeleteQuestion({@required this.questionId, @required this.index, @required this.context});
}