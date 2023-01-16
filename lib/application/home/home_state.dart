part of 'home_bloc.dart';

@immutable
class HomeState {
  final bool shouldRebuildHomeBlogs;
  final bool shouldRebuildHomeQAA;
  const HomeState({@required this.shouldRebuildHomeQAA, @required this.shouldRebuildHomeBlogs});

  copyWith({
    bool shouldRebuildHomeBlogs,
    bool shouldRebuildHomeQAA,
  }) {
    return HomeState(
      shouldRebuildHomeBlogs: shouldRebuildHomeBlogs ?? this.shouldRebuildHomeBlogs,
      shouldRebuildHomeQAA: shouldRebuildHomeQAA ?? this.shouldRebuildHomeQAA,
    );
  }
}
