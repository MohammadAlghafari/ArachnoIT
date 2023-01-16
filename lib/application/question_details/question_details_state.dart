part of 'question_details_bloc.dart';

class QuestionDetailsState {
  const QuestionDetailsState();

  @override
  List<Object> get props => [];
}

class LoadingState extends QuestionDetailsState {}

class QuestionDetailsFetchedState extends QuestionDetailsState {
  QuestionDetailsFetchedState({
    this.questionDetails,
  });

  final QuestionDetailsResponse questionDetails;

  @override
  List<Object> get props => [questionDetails];
}

class SendReportSuccess extends QuestionDetailsState {
  final String message;
  SendReportSuccess({this.message});
}

class RemoteValidationErrorState extends QuestionDetailsState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  @override
  List<Object> get props => [remoteValidationErrorMessage];
}

class RemoteServerErrorScreenActionState extends QuestionDetailsState {
  RemoteServerErrorScreenActionState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}
class RemoteServerErrorState extends QuestionDetailsState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorScreenActionState extends QuestionDetailsState {
  RemoteClientErrorScreenActionState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  @override
  List<Object> get props => [remoteClientErrorMessage];
}
class RemoteClientErrorState extends QuestionDetailsState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  @override
  List<Object> get props => [remoteClientErrorMessage];
}

class VoteUsefulState extends QuestionDetailsState {
  const VoteUsefulState({this.vote});

  final bool vote;
  @override
  List<Object> get props => [vote];
}

class AnswerUpdatedFileListState extends QuestionDetailsState {
  final List<FileResponse> files;
  AnswerUpdatedFileListState({this.files});
}

class SucessAddNewAnswer extends QuestionDetailsState {
  final QuestionAnswerResponse answerResponse;
  SucessAddNewAnswer({this.answerResponse});
}

class SuccessUpdateAnswerSuccess extends QuestionDetailsState {
  final String newBody;
  final List<FileResponse> files;
  final int selectAnswerIndex;
  SuccessUpdateAnswerSuccess({this.newBody, this.files, this.selectAnswerIndex});
}

class SuccessDeleteAnswer extends QuestionDetailsState {
  final int selectAnswerIndex;
  SuccessDeleteAnswer({this.selectAnswerIndex});
}

class IsUpdateClickState extends QuestionDetailsState {
  final bool state;
  IsUpdateClickState({this.state});
}