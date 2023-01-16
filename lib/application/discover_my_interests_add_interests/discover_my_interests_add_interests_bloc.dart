import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/category_response.dart';
import 'package:arachnoit/infrastructure/common_response/sub_category_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
part 'discover_my_interests_add_interests_event.dart';
part 'discover_my_interests_add_interests_state.dart';

class DiscoverMyInterestsAddInterestsBloc
    extends Bloc<DiscoverMyInterestsAddInterestsEvent, DiscoverMyInterestsAddInterestsState> {
  CatalogFacadeService catalogService;
  DiscoverMyInterestsAddInterestsBloc({this.catalogService})
      : assert(catalogService != null),
        super(DiscoverMyInterestsAddInterestsState());

  @override
  Stream<DiscoverMyInterestsAddInterestsState> mapEventToState(
      DiscoverMyInterestsAddInterestsEvent event) async* {
    if (event is FetchMyInterestAddInterest) {
      yield* _mapFetchMyInterestAddInterest(event);
    } else if (event is ChangeMyInterestClickEvent) {
      yield* _mapChangeMyInterestAddInterestState(event);
    } else if (event is UpdateSubCategoryStateFromNotificationIcon) {
      yield* _mapUpdateSubCategoryStateFromNotificationIcon(event);
    } else if (event is UpdateSubCategoryStateFromBottomSheet) {
      yield* _mapUpdateSubCategoryStateFromBottomSheet(event);
    } else if (event is SendActionSubscrption) {
      yield* _mapSendActionSubscrption(event);
    }
  }

  Stream<DiscoverMyInterestsAddInterestsState> _mapSendActionSubscrption(
      SendActionSubscrption event) async* {
    print("th lkdsmf;lsdmf ${GlobalPurposeFunctions.getUserObject().accessToken}");
    List<Map<String, dynamic>> _param = [];
    for (int i = 0; i < event.categoryResponse.length; i++) {
      int counter = 0;
      if (event.categoryResponse[i].subCategories.length == 0) {
        _param.add({
          "topic": "string",
          "sourceId": event.categoryResponse[i].id,
          "sourceType": 0,
          "hitPlatform": 0,
          "status": event.categoryResponse[i].isSubscribedTo
        });
        continue;
      }
      for (SubCategoryResponse item in event.categoryResponse[i].subCategories) {
        if (item.isSubscribedTo) counter++;
        _param.add({
          "topic": "string",
          "sourceId": item.id,
          "sourceType": 1,
          "hitPlatform": 0,
          "status": item.isSubscribedTo
        });
      }
      if (counter == event.categoryResponse[i].subCategories.length) {
        _param.add({
          "topic": "string",
          "sourceId": event.categoryResponse[i].id,
          "sourceType": 0,
          "hitPlatform": 0,
          "status": true
        });
      } else {
        _param.add({
          "topic": "string",
          "sourceId": event.categoryResponse[i].id,
          "sourceType": 0,
          "hitPlatform": 0,
          "status": false
        });
      }
    }
    try {
      ResponseWrapper<bool> favoriteResponse = await catalogService.actionSubscrption(_param);
      if (favoriteResponse.data == true) {
        yield SuccessSendActionSubscrption(message: favoriteResponse.successMessage);
        return;
      } else {
        yield FailedSendActionSubscrption(message: favoriteResponse.errorMessage);
        return;
      }
    } catch (e) {
      yield FailedSendActionSubscrption(message: "Error Happened try again");
    }
  }

  Stream<DiscoverMyInterestsAddInterestsState> _mapUpdateSubCategoryStateFromBottomSheet(
      UpdateSubCategoryStateFromBottomSheet event) async* {
    List<SubCategoryResponse> items = event.items.subCategories;
    int numberOfSubCategoriesSelected = 0;
    for (int i = 0; i < items.length; i++) {
      if (items[i].isSubscribedTo) numberOfSubCategoriesSelected++;
    }
    if (numberOfSubCategoriesSelected == items.length)
      event.items.isSubscribedTo = true;
    else
      event.items.isSubscribedTo = false;
    yield SuccessUpdateSubCategoryState(categoryResponse: event.items, index: event.index);
  }

  Stream<DiscoverMyInterestsAddInterestsState> _mapUpdateSubCategoryStateFromNotificationIcon(
      UpdateSubCategoryStateFromNotificationIcon event) async* {
    List<SubCategoryResponse> items = event.items.subCategories;
    for (int i = 0; i < items.length; i++) {
      event.items.subCategories[i].isSubscribedTo = event.subScripeAll;
    }
    event.items.isSubscribedTo = event.subScripeAll;
    yield SuccessUpdateSubCategoryState(categoryResponse: event.items, index: event.index);
  }

  Stream<DiscoverMyInterestsAddInterestsState> _mapChangeMyInterestAddInterestState(
      ChangeMyInterestClickEvent event) async* {
    CategoryResponse categoryResponse;
    categoryResponse = event.categoryResponse;
    categoryResponse.subCategories[event.index].isSubscribedTo =
        !categoryResponse.subCategories[event.index].isSubscribedTo;
    yield ChangeCategoryStateByClickItem(categoryResponse: categoryResponse, index: event.index);
  }

  Stream<DiscoverMyInterestsAddInterestsState> _mapFetchMyInterestAddInterest(
      FetchMyInterestAddInterest event) async* {
    if (!event.isRefreshData) yield LoadingState();
    try {
      ResponseWrapper<List<CategoryResponse>> categoriesResponse =
          await catalogService.getMyInterestSubCategories();
      switch (categoriesResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          {
            yield GetMyInterestAddInterestSuccess(categoryList: categoriesResponse.data);
            break;
          }
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
}
