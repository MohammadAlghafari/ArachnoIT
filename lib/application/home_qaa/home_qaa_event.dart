part of 'home_qaa_bloc.dart';

@immutable
abstract class HomeQaaEvent extends Equatable {
  const HomeQaaEvent();

  @override
  List<Object> get props => [];
}

class HomeQaaPostsFetch extends HomeQaaEvent {}

class ReloadHomeQaaPostsFetch extends HomeQaaEvent {}

class DeleteQuestion extends HomeQaaEvent {
  final String questionId;
  final int index;
  final BuildContext context;
  DeleteQuestion({@required this.questionId, @required this.index, @required this.context});
}
