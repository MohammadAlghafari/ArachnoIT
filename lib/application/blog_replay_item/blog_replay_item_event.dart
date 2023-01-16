part of 'blog_replay_item_bloc.dart';

abstract class ReplayItemEvent extends Equatable {
  const ReplayItemEvent();

  @override
  List<Object> get props => [];
}


class GetProfileBridEvent extends ReplayItemEvent {
  final String userId;
  final BuildContext context;
  GetProfileBridEvent({this.userId,this.context});
}