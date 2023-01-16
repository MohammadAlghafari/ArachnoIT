part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class ChangeSearchScreenEvent extends SearchEvent {
  final int currentIndex;
  ChangeSearchScreenEvent({@required this.currentIndex});
  @override
  List<Object> get props => [currentIndex];
}

class ProviderAdvanceSearch extends SearchEvent {
    @override
  List<Object> get props => [];
}

class SearchFromTextEvent extends SearchEvent {
    @override
  List<Object> get props => [];
}
