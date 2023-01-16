part of 'all_groups_bloc.dart';

abstract class AllGroupsEvent extends Equatable {
  const AllGroupsEvent();

  @override
  List<Object> get props => [];
}

class AllGroupsFetchEvent extends AllGroupsEvent {
  final bool reloadDataFromFirst;
  AllGroupsFetchEvent({this.reloadDataFromFirst=false});
}
