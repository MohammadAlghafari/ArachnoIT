part of 'pending_list_group_bloc.dart';

abstract class PendingListGroupEvent extends Equatable {
  const PendingListGroupEvent();

  @override
  List<Object> get props => [];
}

class GetAllGroups extends PendingListGroupEvent {
  final bool newRequest;
  GetAllGroups({this.newRequest});
}

class RemoveItemFromGroup extends PendingListGroupEvent {
  final int index;
  final String groupId;
  RemoveItemFromGroup({ this.index, @required this.groupId});
}

class AcceptGroupInovation extends PendingListGroupEvent {
  final int index;
  final String groupId;
  AcceptGroupInovation({ this.index, @required this.groupId});
}