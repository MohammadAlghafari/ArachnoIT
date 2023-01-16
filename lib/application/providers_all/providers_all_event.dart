part of 'providers_all_bloc.dart';

abstract class ProvidersAllEvent extends Equatable {
  const ProvidersAllEvent();

  @override
  List<Object> get props => [];
}

class ProvidersAllFetch extends ProvidersAllEvent {
  final bool rebuildScreen;
  ProvidersAllFetch({this.rebuildScreen = false});
}

class RemoveItemFromMap extends ProvidersAllEvent {
  final String id;
  RemoveItemFromMap({this.id});
}
