import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/category_response.dart';
import '../../infrastructure/common_response/sub_category_response.dart';

part 'discover_my_interest_event.dart';
part 'discover_my_interest_state.dart';

class DiscoverMyInterestBloc extends Bloc<DiscoverMyInterestEvent, DiscoverMyInterestState> {
  DiscoverMyInterestBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(DiscoverMyInterestState());
  CatalogFacadeService catalogService;
  @override
  Stream<DiscoverMyInterestState> mapEventToState(DiscoverMyInterestEvent event) async* {
    if (event is FetchMyInterestSubCategories) {
      yield* _mapFetchMyInterestSubCategories(event);
    }
  }

  Stream<DiscoverMyInterestState> _mapFetchMyInterestSubCategories(
      FetchMyInterestSubCategories event) async* {
    if (!event.reloadData) yield LoadingState();
    try {
      ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getMyInterestSubCategories();
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetMyInterestSubCategoriesSuccess(
              subCatergories: getAllSubCategories(categoriesResponse.data));
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
              remoteValidationErrorMessage: categoriesResponse.errorMessage);
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(remoteServerErrorMessage: categoriesResponse.errorMessage);
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      yield RemoteClientErrorState();
    }
  }

  List<SubCategoryResponse> getAllSubCategories(List<CategoryResponse> categoryResponse) {
    List<SubCategoryResponse> subCategory = List<SubCategoryResponse>();
    for (int i = 0; i < categoryResponse.length; i++) {
      for (int j = 0; j < categoryResponse[i].subCategories.length; j++) {
        if (categoryResponse[i].subCategories[j].isSubscribedTo)
          subCategory.add(categoryResponse[i].subCategories[j]);
      }
    }
    return subCategory;
  }
}
