part of 'group_details_bloc.dart';

abstract class GroupDetailsEvent extends Equatable {
  const GroupDetailsEvent();

  @override
  List<Object> get props => [];
}
class RefreshChangeTabsEvent extends GroupDetailsEvent{}

class FetchGroupDetailsEvent extends GroupDetailsEvent {
  FetchGroupDetailsEvent({this.groupId});
  final String groupId;

  @override
  List<Object> get props => [groupId];
}

class DisableEncodedHintMessageEvent extends GroupDetailsEvent {
  DisableEncodedHintMessageEvent({this.groupId, this.map});
  final String groupId;
  final Map<String, dynamic> map;

  @override
  List<Object> get props => [groupId, map];
}

class InjectedInviteGroup extends GroupDetailsEvent{
final String groupId;

const InjectedInviteGroup({@required this.groupId});
}

class AcceptedInviteGroup extends GroupDetailsEvent{
  final String groupId;

  const AcceptedInviteGroup({@required this.groupId});
}


class JoinToGroupEvent extends GroupDetailsEvent {
  final String groupId;
  JoinToGroupEvent({this.groupId});
}

class DeleteGroupEvent extends GroupDetailsEvent {
  final String groupId;
  DeleteGroupEvent({this.groupId});
}