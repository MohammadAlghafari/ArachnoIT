part of 'blog_replay_item_bloc.dart';

abstract class ReplayItemState extends Equatable {
  const ReplayItemState();

  @override
  List<Object> get props => [];
}

class BlogReplayItemInitial extends ReplayItemState {}

class GetBriedProfileSuceess extends ReplayItemState {
  final BriefProfileResponse profileInfo;
  GetBriedProfileSuceess({this.profileInfo});
}

class RemoteValidationErrorState extends ReplayItemState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends ReplayItemState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends ReplayItemState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}