part of 'question_replay_details_bloc.dart';

@immutable
abstract class QuestionReplayDetailsEvent {
  const QuestionReplayDetailsEvent();
}

class AddNewReplay extends QuestionReplayDetailsEvent {
  final String comment;
  final String postId;
  AddNewReplay({this.comment, this.postId});
}

class UpdateReplay extends QuestionReplayDetailsEvent {

  final String answerId;
  final String message;
  final String replayCommentId;
  final int selectCommentIndex;
  UpdateReplay(
      {this.answerId, this.message, this.replayCommentId, this.selectCommentIndex});
}

class DeleteReplay extends QuestionReplayDetailsEvent {
  final String commentId;
  final int selectCommentIndex;
  DeleteReplay({this.commentId, this.selectCommentIndex});
}

class FetchAllComment extends QuestionReplayDetailsEvent {

  final String questionId;
  final String answerId;
  final bool isRefreshData;
  FetchAllComment({this.questionId,this.answerId,this.isRefreshData=false});
}

class IsUpdateClickEvent extends QuestionReplayDetailsEvent {
  final bool state;
  IsUpdateClickEvent({this.state});
}

class SendReport extends QuestionReplayDetailsEvent {
  final String commentId;
  final String description;
  SendReport({this.commentId, this.description});
}
