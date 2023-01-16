part of 'pending_list_group_bloc.dart';

enum PendingListGroupStatus {
  initial,
  loading,
  success,
  failure,
  successAcceptOrLeaveGroup,
  failedAcceptOrLeaveGroup
}

class PendingListGroupState {
  PendingListGroupState({
    this.hasReachedMax = false,
    this.posts = const <GroupResponse>[],
    this.status = PendingListGroupStatus.initial,
    this.message = "",
  });
  final bool hasReachedMax;
  final PendingListGroupStatus status;
  final List<GroupResponse> posts;
  final String message;
  PendingListGroupState copyWith({
    bool hasReachedMax,
    PendingListGroupStatus status,
    List<GroupResponse> posts,
    String message,
  }) {
    return PendingListGroupState(
        posts: (posts) ?? this.posts,
        hasReachedMax: (hasReachedMax) ?? this.hasReachedMax,
        status: (status) ?? this.status,
        message: (message) ?? this.message);
  }
}

class PenddingListGroupInitial extends PendingListGroupState {}

class LoadingState extends PendingListGroupState {}

class RemoteValidationErrorState extends PendingListGroupState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});
  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends PendingListGroupState {
  RemoteServerErrorState({this.remoteServerErrorMessage});
  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends PendingListGroupState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}
