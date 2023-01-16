part of 'home_qaa_bloc.dart';

enum QaaPostStatus { initial, success, failure ,loading}

@immutable
class HomeQaaState  {
  const HomeQaaState({
    this.status = QaaPostStatus.initial,
    this.posts = const <QaaResponse>[],
    this.hasReachedMax = false,
  });

  final QaaPostStatus status;
  final List<QaaResponse> posts;
  final bool hasReachedMax;

  HomeQaaState copyWith({
    QaaPostStatus status,
    List<QaaResponse> posts,
    bool hasReachedMax,
  }) {
    return HomeQaaState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
