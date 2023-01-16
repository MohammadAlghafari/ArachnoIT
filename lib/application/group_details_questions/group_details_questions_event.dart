part of 'group_details_questions_bloc.dart';

abstract class GroupDetailsQuestionsEvent extends Equatable {
  const GroupDetailsQuestionsEvent();

  @override
  List<Object> get props => [];
}

class GroupQuestionPostsFetched extends GroupDetailsQuestionsEvent {
  GroupQuestionPostsFetched({
    this.groupId,
    this.refreshData=false
  });
  final String groupId;
  final bool refreshData;
  @override
  List<Object> get props => [groupId];
}


class DeleteQuestion extends GroupDetailsQuestionsEvent {
  final String questionId;
  final int index;
  final BuildContext context;
  DeleteQuestion({@required this.questionId, @required this.index, @required this.context});
}