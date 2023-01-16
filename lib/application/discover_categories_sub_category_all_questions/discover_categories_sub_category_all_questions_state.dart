part of 'discover_categories_sub_category_all_questions_bloc.dart';

enum QaaPostStatus { initial, success, failure ,loading}

@immutable
class DiscoverCategoriesSubCategoryAllQuestionsState  {
  const DiscoverCategoriesSubCategoryAllQuestionsState({
    this.status = QaaPostStatus.initial,
    this.posts = const <QaaResponse>[],
    this.hasReachedMax = false,
  });

  final QaaPostStatus status;
  final List<QaaResponse> posts;
  final bool hasReachedMax;

  DiscoverCategoriesSubCategoryAllQuestionsState copyWith({
    QaaPostStatus status,
    List<QaaResponse> posts,
    bool hasReachedMax,
  }) {
    return DiscoverCategoriesSubCategoryAllQuestionsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

}
