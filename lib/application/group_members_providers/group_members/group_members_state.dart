part of 'group_members_bloc.dart';


enum GroupMembersStatus{initial, success, failureValidation,loadingData,serverError,networkError}
enum RemoveMembersFromGroupStatus{initial, success,errorRemove, failureValidation,loadingData,serverError,networkError}
enum RefreshMembersGroupStatus{initial, success,errorRemove, failureValidation,loadingData,serverError,networkError}



class GroupMembersState {
  final String personIdRemoved;
  final GroupMembersStatus status;
  final RemoveMembersFromGroupStatus removeStatus;
  final RefreshMembersGroupStatus refreshMembersGroupStatus;
  final bool hasReachedMax;
  final bool noMembersYet;
  final List<GetGroupMembersResponse> members;
  const GroupMembersState({
  this.status= GroupMembersStatus.initial,
  this.personIdRemoved,
  this.noMembersYet=false,

  this.removeStatus= RemoveMembersFromGroupStatus.initial,
  this.refreshMembersGroupStatus= RefreshMembersGroupStatus.initial,
  this.hasReachedMax=false,
  this.members=const <GetGroupMembersResponse>[],

});

  GroupMembersState copyWith({
     GroupMembersStatus status,
     String personIdRemoved,
bool noMembersYet,
     RemoveMembersFromGroupStatus removeStatus,
    RefreshMembersGroupStatus refreshMembersGroupStatus,
     bool hasReachedMax,
     List<GetGroupMembersResponse> members,
}){
    return GroupMembersState(
      hasReachedMax: hasReachedMax??this.hasReachedMax,
      personIdRemoved: personIdRemoved??this.personIdRemoved,
      noMembersYet: noMembersYet??this.noMembersYet,

      status: status??this.status,
      removeStatus: removeStatus??this.removeStatus,
      refreshMembersGroupStatus: refreshMembersGroupStatus??this.refreshMembersGroupStatus,
      members: members??this.members,
    );
  }
  @override
  // TODO: implement props
  List<Object> get props =>[status,hasReachedMax,members,removeStatus,refreshMembersGroupStatus];

}