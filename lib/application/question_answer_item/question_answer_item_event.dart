part of 'question_answer_item_bloc.dart';

abstract class QuestionAnswerItemEvent extends Equatable {
  const QuestionAnswerItemEvent();

  @override
  List<Object> get props => [];
}

class DownloadFileEvent extends QuestionAnswerItemEvent {
  const DownloadFileEvent({this.url,this.fileName});
  
  final String url;
  final String fileName;
  @override
  List<Object> get props => [url,fileName];
}

class VoteEmphasisEvent extends QuestionAnswerItemEvent {
  const VoteEmphasisEvent({this.itemId,this.status});
  
  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId,status];
}

 class VoteUsefulEvent extends QuestionAnswerItemEvent {
  const VoteUsefulEvent({this.itemId,this.status});
  
  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId,status];
}


class GetProfileBridEvent extends QuestionAnswerItemEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}