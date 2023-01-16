import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/catalog_facade_service.dart';

part 'providers_event.dart';
part 'providers_state.dart';

class ProvidersBloc extends Bloc<ProvidersEvent, ProvidersState> {
  ProvidersBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const ProvidersState());

  final CatalogFacadeService catalogService;

  @override
  Stream<ProvidersState> mapEventToState(
    ProvidersEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
