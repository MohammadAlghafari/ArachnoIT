import 'dart:async';

import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/home_blog/response/get_blogs_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../common/global_prupose_functions.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/vote_response.dart';

part 'blog_list_item_event.dart';
part 'blog_list_item_state.dart';

class BlogListItemBloc extends Bloc<BlogListItemEvent, BlogListItemState> {
  BlogListItemBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const BlogListItemState());

  final CatalogFacadeService catalogService;

  @override
  Stream<BlogListItemState> mapEventToState(
    BlogListItemEvent event,
  ) async* {
    if (event is VoteEmphasisEvent)
      yield* _mapSetEmphasisToState(event);
    else if (event is VoteUsefulEvent)
      yield* _mapSetUsefulToState(event);
    else if (event is DownloadFileEvent)
      yield* _mapDownloadFileToState(event);
    else if (event is GetProfileBridEvent)
      yield* _mapGetProfileBridEvent(event);
    else if (event is UpdateEmphasesAndUsefulManula) {
      yield UpdateEmphasesAndUsefulManulaState(
        emphasesCount: event.emphasesCount,
        usefulCount: event.usefulCount,
      );
    } else if (event is SendReport) {
      yield* _mapSendReport(event);
    }else if(event is UpdateBlogPostObject){
      yield SuccessUpdateObject(newBlogItem: event.newBlogItem);
    }
  }

  Stream<BlogListItemState> _mapSendReport(SendReport event) async* {
    try {
      ResponseWrapper<bool> res = await catalogService.sendBlogsReport(
          blogID: event.blogId, message: event.description);
      if (res.data == true) {
        yield SendReportSuccess(message: res.successMessage);
        return;
      } else {
        yield FailedSendReport(message: res.errorMessage);
        return;
      }
    } catch (e) {
      yield FailedSendReport(message: "Error happened try again");
      return;
    }
  }

  Stream<BlogListItemState> _mapGetProfileBridEvent(
      GetProfileBridEvent event) async* {
    GlobalPurposeFunctions.showOrHideProgressDialog(event.context, true);
    try {
      final ResponseWrapper<BriefProfileResponse> briefProfileResponse =
          await catalogService.getBriefProfile(id: event.userId);
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
      yield RemoteClientErrorState(remoteClientErrorMessage: "");
    }
  }

  Stream<BlogListItemState> _mapSetEmphasisToState(
      VoteEmphasisEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setEmphasisVoteForBlog(
        itemId: event.itemId,
        status: event.status,
      );
      switch (voteResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield VoteEmphasisState(vote: voteResponse.data.status);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(
            remoteClientErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } on Exception catch (_) {}
  }

  Stream<BlogListItemState> _mapSetUsefulToState(VoteUsefulEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setUsefulVoteForBlog(
        itemId: event.itemId,
        status: event.status,
      );
      switch (voteResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield VoteUsefulState(vote: voteResponse.data.status);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState(
            remoteClientErrorMessage: voteResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } on Exception catch (_) {}
  }

  Stream<BlogListItemState> _mapDownloadFileToState(
    DownloadFileEvent event,
  ) async* {
    try {
      GlobalPurposeFunctions.downloadFile(event.url, event.fileName);
    } on Exception catch (_) {}
  }
}
