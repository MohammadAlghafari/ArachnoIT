part of 'group_details_bloc.dart';

class GroupDetailsState  {
  const GroupDetailsState();

}

class LoadingState extends GroupDetailsState {}

class GroupDetailsFetchedState extends GroupDetailsState {
  GroupDetailsFetchedState({
    this.groupDetails,
  });

  final GroupDetailsResponse groupDetails;

}

class RefreshChangeTabs extends GroupDetailsState{}


class DisableEncodedHintMessageState extends GroupDetailsState {}

class RemoteValidationErrorState extends GroupDetailsState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}


class DeleteGroupLoading extends GroupDetailsState{

}
class SuccessDeleteGroup extends GroupDetailsState{
 final DeleteGroupResponse deleteGroupResponse;
  const SuccessDeleteGroup({@required this.deleteGroupResponse});
}


class RemoteServerErrorState extends GroupDetailsState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends GroupDetailsState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}


class SuccessToAcceptedToGroup extends GroupDetailsState{
  final String successOperation;
  const SuccessToAcceptedToGroup({@required this.successOperation});
}

class FailureToAcceptedToGroup extends GroupDetailsState{
  const FailureToAcceptedToGroup();
}



class SuccessJoinedToGroup extends GroupDetailsState {
  final String message;
  final JoinedGroupResponse joinedGroupResponse;
  SuccessJoinedToGroup({this.message,this.joinedGroupResponse});
}

class FailedJoinedToGroup extends GroupDetailsState {
  final String message;
  FailedJoinedToGroup({this.message});
}
