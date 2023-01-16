part of 'latest_version_bloc.dart';

abstract class LatestVersionEvent extends Equatable {
  const LatestVersionEvent();

  @override
  List<Object> get props => [];
}

class CheckVersion extends LatestVersionEvent{
final BuildContext context;
CheckVersion({@required this.context});
}