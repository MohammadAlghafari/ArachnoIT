import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/catalog_facade_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const HomeState(
          shouldRebuildHomeBlogs: false,
          shouldRebuildHomeQAA: false,
        ));

  final CatalogFacadeService catalogService;
  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is ChangeDestroyQAAStatus) {
      yield state.copyWith(shouldRebuildHomeQAA: event.destoryStatus);
    } else if (event is ChangeDestroyBlogsStatus) {
      yield state.copyWith(shouldRebuildHomeBlogs: event.destoryStatus);
    }
  }
}
