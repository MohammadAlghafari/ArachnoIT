part of 'discover_my_interests_sub_categories_qaa_bloc.dart';

enum QaaMyInterestsSubCategoriesQaaStatus { initial, success, failure, loading }

class DiscoverMyInterestsSubCategoriesQaaState  {
  final QaaMyInterestsSubCategoriesQaaStatus status;
  final List<QaaResponse> posts;
  final bool hasReachedMax;

  const DiscoverMyInterestsSubCategoriesQaaState(
      {this.hasReachedMax = false,
      this.posts = const <QaaResponse>[],
      this.status = QaaMyInterestsSubCategoriesQaaStatus.initial});

  copyWith(
      {QaaMyInterestsSubCategoriesQaaStatus status,
      List<QaaResponse> posts,
      bool hasReachedMax}) {
    return DiscoverMyInterestsSubCategoriesQaaState(
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        posts: posts ?? this.posts,
        status: status ?? this.status);
  }

}
