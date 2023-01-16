part of 'question_details_bloc.dart';

abstract class QuestionDetailsEvent {
  const QuestionDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchQuestionDetailsEvent extends QuestionDetailsEvent {
  const FetchQuestionDetailsEvent({
    this.questionId,
    this.isRefreshData=false
  });

  final String questionId;
  final bool isRefreshData;
  @override
  List<Object> get props => [questionId];
}

class SendReport extends QuestionDetailsEvent {
  final String commentId;
  final String description;
  SendReport({this.commentId, this.description});
}

class DownloadFileEvent extends QuestionDetailsEvent {
  const DownloadFileEvent({this.url, this.fileName});

  final String url;
  final String fileName;
  @override
  List<Object> get props => [url, fileName];
}

class VoteUsefulEvent extends QuestionDetailsEvent {
  const VoteUsefulEvent({this.itemId, this.status});

  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId, status];
}

class AnswerUpdateFilesListEvent extends QuestionDetailsEvent {
  final List<FileResponse> files;
  AnswerUpdateFilesListEvent({this.files});
}

class AnswerRemoveFileItem extends QuestionDetailsEvent {
  final int index;
  final List<FileResponse> files;
  AnswerRemoveFileItem({
    @required this.index,
    @required this.files,
  });
}

class RemoveAnswerFromQuestion extends QuestionDetailsEvent {
  final String answerId;
  final int selectAnswerIndex;
  const  RemoveAnswerFromQuestion({@required this.answerId,@required this.selectAnswerIndex});
}

class AddNewAnswer extends QuestionDetailsEvent {
  final String answer;
  final List<FileResponse> files;
  final String postId;
  AddNewAnswer({this.answer, this.files, this.postId});
}

class UpdateAnswer extends QuestionDetailsEvent {
  final String answer;
  final String postId;
  final String answerId;
  final int selectAnswerIndex;
  final List<FileResponse> files;
  final List<String> removedFiles;
  UpdateAnswer(
      {this.answer,
      this.postId,
      this.answerId,
      this.files,
      this.removedFiles,
      this.selectAnswerIndex});
}

class IsUpdateClickEvent extends QuestionDetailsEvent {
  final bool state;
  IsUpdateClickEvent({this.state});
}

