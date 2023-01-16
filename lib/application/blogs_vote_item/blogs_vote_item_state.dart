part of 'blogs_vote_item_bloc.dart';

abstract class BlogsVoteItemState  {
  const BlogsVoteItemState();

}

class BlogsVoteItemInitial extends BlogsVoteItemState {}

class GetBriedProfileSuceess extends BlogsVoteItemState {
  final BriefProfileResponse profileInfo;
  GetBriedProfileSuceess({this.profileInfo});
}

class RemoteValidationErrorState extends BlogsVoteItemState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends BlogsVoteItemState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends BlogsVoteItemState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}