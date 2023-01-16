part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ChangeDestroyQAAStatus extends HomeEvent {
  final bool destoryStatus;
  ChangeDestroyQAAStatus({this.destoryStatus});
}

class ChangeDestroyBlogsStatus extends HomeEvent {
  final bool destoryStatus;
  ChangeDestroyBlogsStatus({this.destoryStatus});
}