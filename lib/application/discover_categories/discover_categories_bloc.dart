import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/category_response.dart';

part 'discover_categories_event.dart';
part 'discover_categories_state.dart';

class DiscoverCategoriesBloc
    extends Bloc<DiscoverCategoriesEvent, DiscoverCategoriesState> {
  DiscoverCategoriesBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const DiscoverCategoriesState());

  final CatalogFacadeService catalogService;

  @override
  Stream<DiscoverCategoriesState> mapEventToState(
    DiscoverCategoriesEvent event,
  ) async* {
    if (event is GetCategoriesEvent) {
      yield* _mapCategoriesToState(event);
    }
  }

  Stream<DiscoverCategoriesState> _mapCategoriesToState(
      GetCategoriesEvent event) async* {
    try {
      if (!event.isRefreshData) yield LoadingState();
      final ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getCategories();
      print("teh event.isRefreshData is ${event.isRefreshData}");
      if (event.isRefreshData &&
          categoriesResponse.responseType != ResType.ResponseType.SUCCESS) {
        yield ErrorRefreshData();
        return;
      }
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetCategoriesSucessfulState(
              categories: categoriesResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: categoriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: categoriesResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {}
  }
}
