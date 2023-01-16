import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/provider_item_response.dart';

part 'providers_favorite_event.dart';
part 'providers_favorite_state.dart';

const _providersLimit = 20;

class ProvidersFavoriteBloc extends Bloc<ProvidersFavoriteEvent, ProvidersFavoriteState> {
  ProvidersFavoriteBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(ProvidersFavoriteState());

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<ProvidersFavoriteEvent, ProvidersFavoriteState>> transformEvents(
    Stream<ProvidersFavoriteEvent> events,
    TransitionFunction<ProvidersFavoriteEvent, ProvidersFavoriteState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ProvidersFavoriteState> mapEventToState(
    ProvidersFavoriteEvent event,
  ) async* {
    if (event is ProvidersFavoriteFetch) {
      yield* _mapProvidersFavoriteFetchToState(state, event);
    } else if (event is DeleteItem) {
      state.providers.removeAt(event.index);
      yield state.copyWith(providers: state.providers);
    } else if (event is AddItemToArray) {
      List<ProviderItemResponse> item = state.providers;
      item.add(event.providerItemResponse);
      yield state.copyWith(
        providers: item,
      );
    } else if (event is RemoveItemFromFavouriteMap) {
      yield* _mapRemoveItemFromFavouriteMap(event);
    }
  }

  Stream<ProvidersFavoriteState> _mapRemoveItemFromFavouriteMap(
      RemoveItemFromFavouriteMap event) async* {
    List<ProviderItemResponse> items = state.providers;
    if (items.length == 0)
      yield state;
    else {
      if (event.index != -1) {
        items.removeAt(event.index);
      } else {
        int index = 0;
        for (ProviderItemResponse item in state.providers) {
          if (item.id == event.id) {
            items.removeAt(index);
            break;
          }
          index++;
        }
      }
      yield state.copyWith(providers: items);
    }
  }

  Stream<ProvidersFavoriteState> _mapProvidersFavoriteFetchToState(
      ProvidersFavoriteState state, ProvidersFavoriteFetch event) async* {
    if (state.providers.length == 0) {
      yield state.copyWith(status: ProvidersFavoriteStatus.loading);
    }
    if (state.hasReachedMax && !event.rebuildScreen) {
      yield state;
      return;
    }

    try {
      if (state.status == ProvidersFavoriteStatus.initial || event.rebuildScreen) {
        final providers = await _fetchProvidersAll();

        yield state.copyWith(
          status: ProvidersFavoriteStatus.success,
          providers: providers,
          hasReachedMax: _hasReachedMax(providers.length),
        );
        return;
      }
      final providers =
          await _fetchProvidersAll((state.providers.length / _providersLimit).round());

      yield providers.isEmpty
          ? state.copyWith(
              hasReachedMax: true,
              status: ProvidersFavoriteStatus.success,
            )
          : state.copyWith(
              status: ProvidersFavoriteStatus.success,
              providers: List.of(state.providers)..addAll(providers),
              hasReachedMax: _hasReachedMax(providers.length),
            );
      return;
    } catch (e) {
      yield state.copyWith(status: ProvidersFavoriteStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<ProviderItemResponse>> _fetchProvidersAll([int startIndex = 0]) async {
    try {
      final response = await catalogService.getFavoriteProviders(
        searchString: '',
        pageNumber: startIndex,
        pageSize: _providersLimit,
      );
      print("the response response${response.responseType}");
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching providers');
    } catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _providersLimit ? true : false;
}
