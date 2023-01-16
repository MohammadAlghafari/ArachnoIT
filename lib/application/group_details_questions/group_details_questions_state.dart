part of 'group_details_questions_bloc.dart';

enum QaaPostStatus { initial, success, failure, loading }

@immutable
class GroupDetailsQuestionsState {
  const GroupDetailsQuestionsState({
    this.status = QaaPostStatus.initial,
    this.posts = const <QaaResponse>[],
    this.hasReachedMax = false,
  });

  final QaaPostStatus status;
  final List<QaaResponse> posts;
  final bool hasReachedMax;

  GroupDetailsQuestionsState copyWith({
    QaaPostStatus status,
    List<QaaResponse> posts,
    bool hasReachedMax,
  }) {
    return GroupDetailsQuestionsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
