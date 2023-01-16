import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/provider_item_response.dart';

part 'providers_all_event.dart';
part 'providers_all_state.dart';

const _providersLimit = 20;

class ProvidersAllBloc extends Bloc<ProvidersAllEvent, ProvidersAllState> {
  ProvidersAllBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(ProvidersAllState(indexItem: {}));

  final CatalogFacadeService catalogService;

  @override
  Stream<Transition<ProvidersAllEvent, ProvidersAllState>> transformEvents(
    Stream<ProvidersAllEvent> events,
    TransitionFunction<ProvidersAllEvent, ProvidersAllState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ProvidersAllState> mapEventToState(
    ProvidersAllEvent event,
  ) async* {
    if (event is ProvidersAllFetch) {
      yield* _mapProvidersAllFetchToState(state, event);
    } else if (event is RemoveItemFromMap) {
      yield* _mapRemoveItemFromMap(event);
    }
  }

  Stream<ProvidersAllState> _mapRemoveItemFromMap(RemoveItemFromMap event) async* {
    List<ProviderItemResponse> items = state.providers;
    if (items.length == 0)
      yield state;
    else {
      ProviderItemResponse item = items[state.indexItem[event.id]];
      item.addedToFavoriteList = false;
      items[state.indexItem[event.id]] = item;
      yield state.copyWith(providers: items);
    }
  }

  Stream<ProvidersAllState> _mapProvidersAllFetchToState(
      ProvidersAllState state, ProvidersAllFetch event) async* {
    Map<String, int> mapItem = state.indexItem;

    if (state.providers.length == 0) {
      yield state.copyWith(
          status: ProvidersAllStatus.loading, hasReachedMax: false, providers: [], indexItem: {});
    }
    if (state.hasReachedMax && !event.rebuildScreen) {
      yield state;
      return;
    }
    try {
      if (state.status == ProvidersAllStatus.initial || event.rebuildScreen) {
        final providers = await _fetchProvidersAll();
        int index = state.providers.length;
        print("the index value is $index");
        for (ProviderItemResponse item in providers) {
          mapItem[item.id] = index;
          index++;
        }
        yield state.copyWith(
            status: ProvidersAllStatus.success,
            providers: providers,
            hasReachedMax: _hasReachedMax(providers.length),
            indexItem: mapItem);
        return;
      }
      final providers =
          await _fetchProvidersAll((state.providers.length / _providersLimit).round());
      int index = state.providers.length;
      for (ProviderItemResponse item in providers) {
        mapItem[item.id] = index;
        index++;
      }
      yield providers.isEmpty
          ? state.copyWith(hasReachedMax: true, indexItem: mapItem)
          : state.copyWith(
              status: ProvidersAllStatus.success,
              providers: List.of(state.providers)..addAll(providers),
              hasReachedMax: _hasReachedMax(providers.length),
              indexItem: mapItem);
      return;
    } catch (e) {
      yield state.copyWith(status: ProvidersAllStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<ProviderItemResponse>> _fetchProvidersAll([int startIndex = 0]) async {
    try {
      final response = await catalogService.getAllProviders(
        pageNumber: startIndex,
        pageSize: _providersLimit,
      );
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
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int postsCount) => postsCount < _providersLimit ? true : false;
}
