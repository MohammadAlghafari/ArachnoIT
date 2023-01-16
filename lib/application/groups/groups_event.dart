  part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class PublicAndMyGroupsFetchEvent extends GroupsEvent {}
class RefreshPublicAndMyGroupsFetchEvent extends GroupsEvent {
 final bool isRefreshData;
 RefreshPublicAndMyGroupsFetchEvent({this.isRefreshData=false});
}

class MyGroupsFetchEvent extends GroupsEvent {}
class DeleteGroupAndRefreshed extends GroupsEvent {
  final String groupId;
  const DeleteGroupAndRefreshed({@required this.groupId});
}


class AddGroupAndRefreshed extends GroupsEvent{

}
class UpdateGroupAndRefreshed extends GroupsEvent{
final GroupDetailsResponse groupDetailsResponse;
const UpdateGroupAndRefreshed({@required this.groupDetailsResponse});
  }