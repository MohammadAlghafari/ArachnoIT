part of 'question_answer_item_bloc.dart';

 class QuestionAnswerItemState extends Equatable {
  const QuestionAnswerItemState();
  
  @override
  List<Object> get props => [];
}

class VoteEmphasisState extends QuestionAnswerItemState {
  const VoteEmphasisState({this.vote});

  final bool vote;
   @override
  List<Object> get props => [vote];
}
class VoteUsefulState extends QuestionAnswerItemState {
  const VoteUsefulState({this.vote});

  final bool vote;
   @override
  List<Object> get props => [vote];
}

class RemoteValidationErrorState extends QuestionAnswerItemState {
  RemoteValidationErrorState({this.remoteValidationErrorMessage});

  final String remoteValidationErrorMessage;
  @override
  List<Object> get props => [remoteValidationErrorMessage];
}

class RemoteServerErrorState extends QuestionAnswerItemState {
  RemoteServerErrorState({this.remoteServerErrorMessage});

  final String remoteServerErrorMessage;
  @override
  List<Object> get props => [remoteServerErrorMessage];
}

class RemoteClientErrorState extends QuestionAnswerItemState {
  RemoteClientErrorState({this.remoteClientErrorMessage});

  final String remoteClientErrorMessage;
  @override
  List<Object> get props => [remoteClientErrorMessage];
}


class GetBriedProfileSuceess extends QuestionAnswerItemState {
  final BriefProfileResponse profileInfo;

  GetBriedProfileSuceess({this.profileInfo});
}