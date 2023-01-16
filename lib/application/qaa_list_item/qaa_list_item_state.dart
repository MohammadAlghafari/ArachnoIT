part of 'qaa_list_item_bloc.dart';

class QaaListItemState {
  const QaaListItemState();
}

class LoadingState extends QaaListItemState {}

class QuestionFilesState extends QaaListItemState {
  const QuestionFilesState({this.questionFiles});

  final List<FileResponse> questionFiles;
}

class VoteUsefulState extends QaaListItemState {
  const VoteUsefulState({this.vote});

  final bool vote;
}

class RemoteValidationErrorState extends QaaListItemState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
}

class RemoteServerErrorState extends QaaListItemState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
}

class RemoteClientErrorState extends QaaListItemState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
}

class SendReportSuccess extends QaaListItemState {
  final String message;
  SendReportSuccess({this.message});
}

class FailedSendReport extends QaaListItemState {
  final String message;
  FailedSendReport({this.message});
}

class GetBriedProfileSuceess extends QaaListItemState {
  final BriefProfileResponse profileInfo;

  GetBriedProfileSuceess({this.profileInfo});
}

class UpdateObjectWhenSuccessUpdateState extends QaaListItemState {
  final QaaResponse qaaResponse;
  UpdateObjectWhenSuccessUpdateState({this.qaaResponse});
}
