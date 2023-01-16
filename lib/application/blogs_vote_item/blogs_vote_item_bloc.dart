import 'dart:async';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:flutter/cupertino.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'blogs_vote_item_event.dart';
part 'blogs_vote_item_state.dart';

class BlogsVoteItemBloc extends Bloc<BlogsVoteItemEvent, BlogsVoteItemState> {
  CatalogFacadeService catalogService;

  BlogsVoteItemBloc({this.catalogService}) : super(BlogsVoteItemInitial());

  @override
  Stream<BlogsVoteItemState> mapEventToState(BlogsVoteItemEvent event) async* {
    if (event is GetProfileBridEvent) {
      yield* _mapGetProfileBridEvent(event);
    }
  }

  Stream<BlogsVoteItemState> _mapGetProfileBridEvent(
      GetProfileBridEvent event) async* {
    try {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
      final ResponseWrapper<BriefProfileResponse> briefProfileResponse =
          await catalogService.getVoteBriefProfile(id: event.userId);
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      switch (briefProfileResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetBriedProfileSuceess(profileInfo: briefProfileResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(
            remoteClientErrorMessage: briefProfileResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (e) {
      GlobalPurposeFunctions.showOrHideProgressDialog(event.context, false);
      yield RemoteClientErrorState(remoteClientErrorMessage: "");
    }
  }
}
