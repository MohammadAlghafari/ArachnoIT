part of 'discover_my_interest_bloc.dart';

abstract class DiscoverMyInterestEvent extends Equatable {
  const DiscoverMyInterestEvent();

  @override
  List<Object> get props => [];
}

class FetchMyInterestSubCategories extends DiscoverMyInterestEvent {
  final bool reloadData;
  FetchMyInterestSubCategories({this.reloadData=false});
}