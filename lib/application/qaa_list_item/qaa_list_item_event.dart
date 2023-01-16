part of 'qaa_list_item_bloc.dart';

abstract class QaaListItemEvent extends Equatable {
  const QaaListItemEvent();

  @override
  List<Object> get props => [];
}

 class GetQuestionFilesEvent extends QaaListItemEvent {
  const GetQuestionFilesEvent({this.questionId});
  
  final String questionId;
  @override
  List<Object> get props => [questionId];
}

 class DownloadFileEvent extends QaaListItemEvent {
  const DownloadFileEvent({this.url,this.fileName});
  
  final String url;
  final String fileName;
  @override
  List<Object> get props => [url,fileName];
}

 class VoteUsefulEvent extends QaaListItemEvent {
  const VoteUsefulEvent({this.itemId,this.status});
  
  final String itemId;
  final bool status;
  @override
  List<Object> get props => [itemId,status];
}


class SendReport extends QaaListItemEvent {
  final String blogId;
  final String description;
  SendReport({this.blogId, this.description});
}


class GetProfileBridEvent extends QaaListItemEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}

class UpdateObjectWhenSuccessUpdate extends QaaListItemEvent{
  final QaaResponse qaaResponse;
  UpdateObjectWhenSuccessUpdate({this.qaaResponse});
}