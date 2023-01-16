import 'dart:async';

import '../../infrastructure/catalog_facade_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'discover_my_interests_sub_catergories_details_event.dart';
part 'discover_my_interests_sub_catergories_details_state.dart';

class DiscoverMyInterestsSubCatergoriesDetailsBloc extends Bloc<
    DiscoverMyInterestsSubCatergoriesDetailsEvent,
    DiscoverMyInterestsSubCatergoriesDetailsState> {
  CatalogFacadeService catalogFacadeService;

  DiscoverMyInterestsSubCatergoriesDetailsBloc({this.catalogFacadeService})
      : assert(catalogFacadeService != null),
        super(DiscoverMyInterestsSubCatergoriesDetailsState());

  @override
  Stream<DiscoverMyInterestsSubCatergoriesDetailsState> mapEventToState(
      DiscoverMyInterestsSubCatergoriesDetailsEvent event) async* {}
}
