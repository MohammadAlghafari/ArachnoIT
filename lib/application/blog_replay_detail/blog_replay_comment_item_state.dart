part of 'blog_replay_comment_item_bloc.dart';

abstract class BlogReplayDetailState {
  const BlogReplayDetailState();

}

class BlogReplayCommentItemInitial extends BlogReplayDetailState {}

class LoadingState extends BlogReplayDetailState {}

class ErrorState extends BlogReplayDetailState {
  final String errorMessage;
  ErrorState({this.errorMessage});
}

class SuccessAddReplay extends BlogReplayDetailState {
  final CommentReplyResponse blogCommentReplyResponse;
  SuccessAddReplay({@required this.blogCommentReplyResponse});
}

class SuccessDeleteReplay extends BlogReplayDetailState {
  final int index;
  SuccessDeleteReplay({@required this.index});
}

class SuccessUpdateReplay extends BlogReplayDetailState {
  final int index;
  SuccessUpdateReplay({this.index});
}

class RemoteValidationErrorState extends BlogReplayDetailState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends BlogReplayDetailState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends BlogReplayDetailState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class SuccessGetAllComments extends BlogReplayDetailState {
  final CommentResponse comment;
  SuccessGetAllComments({this.comment});
}

class IsUpdateClickState extends BlogReplayDetailState {
  final bool state;
  IsUpdateClickState({this.state});
}

class SendReportSuccess extends BlogReplayDetailState {
  final String message;
  SendReportSuccess({this.message});
}

class FailedSendReport extends BlogReplayDetailState {
   final String message;
  FailedSendReport({this.message});
}
