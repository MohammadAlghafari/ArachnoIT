part of 'group_details_search_questions_bloc.dart';

enum QaaPostStatus { initial, loading, success, failure }

@immutable
class GroupDetailsSearchQuestionsState  {
  const GroupDetailsSearchQuestionsState({
    this.status = QaaPostStatus.initial,
    this.posts = const <QaaResponse>[],
    this.hasReachedMax = false,
  });

  final QaaPostStatus status;
  final List<QaaResponse> posts;
  final bool hasReachedMax;

  GroupDetailsSearchQuestionsState copyWith({
    QaaPostStatus status,
    List<QaaResponse> posts,
    bool hasReachedMax,
  }) {
    return GroupDetailsSearchQuestionsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

}
