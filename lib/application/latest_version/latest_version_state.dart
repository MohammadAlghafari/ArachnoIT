part of 'latest_version_bloc.dart';

abstract class LatestVersionState extends Equatable {
  const LatestVersionState();

  @override
  List<Object> get props => [];
}

class LatestVersionInitial extends LatestVersionState {}

class GoingToMainScreen extends LatestVersionState {}

class FailesGetVersion extends LatestVersionState {}

class SuccessGetVersion extends LatestVersionState {}