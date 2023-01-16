import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/catalog_facade_service.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const DiscoverState());

  final CatalogFacadeService catalogService;
  @override
  Stream<DiscoverState> mapEventToState(
    DiscoverEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
