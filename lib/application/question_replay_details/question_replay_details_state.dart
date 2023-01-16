part of 'question_replay_details_bloc.dart';

@immutable
 class QuestionReplayDetailsState {}

class LoadingState extends QuestionReplayDetailsState {}

class ErrorState extends QuestionReplayDetailsState {
  final String errorMessage;
  ErrorState({this.errorMessage});
}

class SuccessAddReplay extends QuestionReplayDetailsState {
  final QuestionAnswerCommentResponse questionCommentReplyResponse;
  SuccessAddReplay({@required this.questionCommentReplyResponse});
}

class SuccessDeleteReplay extends QuestionReplayDetailsState {
  final int index;
  SuccessDeleteReplay({@required this.index});
}

class SuccessUpdateReplay extends QuestionReplayDetailsState {
  final int index;
  SuccessUpdateReplay({this.index});
}

class RemoteValidationErrorState extends QuestionReplayDetailsState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends QuestionReplayDetailsState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends QuestionReplayDetailsState {
  RemoteClientErrorState({this.remoteClientErrorMessage});
  final String remoteClientErrorMessage;
}

class SuccessGetAllComments extends QuestionReplayDetailsState {
  final QuestionAnswerResponse comment;
  SuccessGetAllComments({this.comment});
}

class IsUpdateClickState extends QuestionReplayDetailsState {
  final bool state;
  IsUpdateClickState({this.state});
}

class SendReportSuccess extends QuestionReplayDetailsState {
  final String message;
  SendReportSuccess({this.message});
}

class FailedSendReport extends QuestionReplayDetailsState {
  final String message;
  FailedSendReport({this.message});
}
