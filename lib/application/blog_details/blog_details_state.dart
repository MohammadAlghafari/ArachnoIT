part of 'blog_details_bloc.dart';

class BlogDetailsState {
  const BlogDetailsState();
}

class LoadingState extends BlogDetailsState {}

class BlogDetailsFetchedState extends BlogDetailsState {
  BlogDetailsFetchedState({
    this.blogDetails,
  });

  final BlogDetailsResponse blogDetails;
}

class VoteEmphasisState extends BlogDetailsState {
  const VoteEmphasisState({this.vote});

  final bool vote;
}

class VoteUsefulState extends BlogDetailsState {
  const VoteUsefulState({this.vote});

  final bool vote;
}

class SucessAddNewComment extends BlogDetailsState {
  final CommentResponse blogCommentReponse;
  SucessAddNewComment({this.blogCommentReponse});
}

class SuccessUpdateCommentSuccess extends BlogDetailsState {
  final String  newBody;
  final int selectCommentIndex;
  SuccessUpdateCommentSuccess(
      {this.newBody, this.selectCommentIndex});
}

class SuccessDeleteComment extends BlogDetailsState {
  final int selectCommentIndex;
  SuccessDeleteComment({this.selectCommentIndex});
}

class RemoteValidationErrorState extends BlogDetailsState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends BlogDetailsState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends BlogDetailsState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class IsUpdateClickState extends BlogDetailsState {
  final bool state;
  IsUpdateClickState({this.state});
}

class ChangeNumberOfReplay extends BlogDetailsState {
  final int index;
  final int numberOfReplay;
  ChangeNumberOfReplay({this.index, this.numberOfReplay});
}

class SendReportSuccess extends BlogDetailsState {
  final String message;
  SendReportSuccess({this.message});
}

class FailedSendReport extends BlogDetailsState {
   final String message;
  FailedSendReport({this.message});
}

class GetBriedProfileSuceess extends BlogDetailsState {
  final BriefProfileResponse profileInfo;

  GetBriedProfileSuceess({this.profileInfo});
}