part of 'search_bloc.dart';

@immutable
class SearchState extends Equatable {
  final int currentIndex;
  final bool shouldDestroyWidget;
  final bool shouldReplaceState;
  SearchState(
      {this.currentIndex = 0,
      this.shouldDestroyWidget = true,
      this.shouldReplaceState = true});
  SearchState copyWith(
      {int index,
      bool shouldDestroyWidget,
      bool changeState,
      bool shouldReplaceState}) {
    return SearchState(
        currentIndex: index ?? this.currentIndex,
        shouldDestroyWidget: (shouldDestroyWidget) ?? this.shouldDestroyWidget,
        shouldReplaceState: (shouldReplaceState) ?? this.shouldReplaceState);
  }

  @override
  List<Object> get props =>
      [currentIndex, shouldDestroyWidget, shouldReplaceState];
}
