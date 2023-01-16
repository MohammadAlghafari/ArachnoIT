part of 'blog_comment_item_bloc.dart';

class CommentItemState {
  const CommentItemState();
}

class VoteUsefulState extends CommentItemState {
  const VoteUsefulState({this.vote});

  final bool vote;
}

class RemoteValidationErrorState extends CommentItemState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends CommentItemState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends CommentItemState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}

class GetBriedProfileSuceess extends CommentItemState {
  final BriefProfileResponse profileInfo;

  GetBriedProfileSuceess({this.profileInfo});
}
