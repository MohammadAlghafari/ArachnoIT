import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_reply_response.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/global_prupose_functions.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/blog_details/response/blog_details_response.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/vote_response.dart';

part 'blog_details_event.dart';
part 'blog_details_state.dart';

class BlogDetailsBloc extends Bloc<BlogDetailsEvent, BlogDetailsState> {
  BlogDetailsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(const BlogDetailsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<BlogDetailsState> mapEventToState(
    BlogDetailsEvent event,
  ) async* {
    if (event is IsUpdateClickEvent)
      yield IsUpdateClickState(state: event.state);
    else if (event is FetchBlogDetailsEvent)
      yield* _mapFetchBlogDetailsToState(event);
    else if (event is VoteEmphasisEvent)
      yield* _mapSetEmphasisToState(event);
    else if (event is VoteUsefulEvent)
      yield* _mapSetUsefulToState(event);
    else if (event is DownloadFileEvent)
      yield* _mapDownloadFileToState(event);
    else if (event is AddNewComment)
      yield* _mapAddNewComment(event);
    else if (event is UpdateComment)
      yield* _mapUpdateComment(event);
    else if (event is DelteComment)
      yield* _mapDeleteComment(event);
    else if (event is GetProfileBridEvent)
      yield* _mapGetProfileBridEvent(event);
    else if (event is ChangeReplayCounterEvent) {
      yield ChangeNumberOfReplay(
          index: event.index, numberOfReplay: event.numberOfReplay);
    } else if (event is SendReport) {
      yield* _mapSendReport(event);
    }
  }

  Stream<BlogDetailsState> _mapGetProfileBridEvent(
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

  Stream<BlogDetailsState> _mapSendReport(SendReport event) async* {
    try {
      ResponseWrapper<bool> res = await catalogService.sendCommentReport(
          commentId: event.commentId, description: event.description);
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

  Stream<BlogDetailsState> _mapDeleteComment(DelteComment event) async* {
    try {
      final ResponseWrapper<bool> blogDetailsResponse =
          await catalogService.deleteComment(commentId: event.commentId);
      switch (blogDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessDeleteComment(
              selectCommentIndex: event.selectCommentIndex);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<BlogDetailsState> _mapUpdateComment(UpdateComment event) async* {
    // print("the comment is ${event.commentId} and post id ${event.postId}");
    try {
      final ResponseWrapper<CommentBodyRespose> blogDetailsResponse =
          await catalogService.updateComment(
              comment: event.comment,
              postId: event.postId,
              commentId: event.commentId);
      switch (blogDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessUpdateCommentSuccess(
              newBody: blogDetailsResponse.data.body,
              selectCommentIndex: event.selectCommentIndex);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<BlogDetailsState> _mapAddNewComment(AddNewComment event) async* {
    try {
      final ResponseWrapper<CommentBodyRespose> blogDetailsResponse =
          await catalogService.setNewComment(
              comment: event.comment, postId: event.postId);
      switch (blogDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          LoginResponse userInfo = LoginResponse.fromMap(
              json.decode(prefs.get(PrefsKeys.LOGIN_RESPONSE)));
          String formattedDate =
              DateFormat('yyyy-MM-dd').format(DateTime.now());
          CommentResponse comment = new CommentResponse(
              id: blogDetailsResponse.data.id ?? "",
              body: event.comment ?? "",
              creationDate: formattedDate,
              usefulCount: 0,
              emphasisCount: 0,
              firstName: userInfo.firstName ?? "",
              lastName: userInfo.lastName ?? "",
              photoUrl: userInfo.photoUrl ?? "",
              inTouchPointName: userInfo.inTouchPointName ?? "",
              personId: userInfo.userId ?? "",
              markedAsEmphasis: false,
              isHealthcareProvider: false,
              markedAsUseful: false,
              replies: <CommentReplyResponse>[]);
          yield SucessAddNewComment(blogCommentReponse: comment);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:
          yield RemoteServerErrorState(
            remoteServerErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:
          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          break;
      }
    } catch (_) {
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<BlogDetailsState> _mapFetchBlogDetailsToState(
    FetchBlogDetailsEvent event,
  ) async* {
    if(!event.isRefreshData)
    yield LoadingState();
    try {
      final ResponseWrapper<BlogDetailsResponse> blogDetailsResponse =
          await catalogService.getBlogDetails(
        blogId: event.blogId,
      );
      switch (blogDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield BlogDetailsFetchedState(blogDetails: blogDetailsResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          yield RemoteValidationErrorState(
            remoteValidationErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.SERVER_ERROR:

          yield RemoteServerErrorState(
            remoteServerErrorMessage: blogDetailsResponse.errorMessage,
          );
          break;
        case ResType.ResponseType.CLIENT_ERROR:

          yield RemoteClientErrorState();
          break;
        case ResType.ResponseType.NETWORK_ERROR:
          yield RemoteClientErrorState();
          break;
      }
    } catch (_) {

      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<BlogDetailsState> _mapSetEmphasisToState(
      VoteEmphasisEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setEmphasisVoteForBlogDetails(
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
    } catch (_) {
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<BlogDetailsState> _mapSetUsefulToState(VoteUsefulEvent event) async* {
    try {
      final ResponseWrapper<VoteResponse> voteResponse =
          await catalogService.setUsefulVoteForBlogDetails(
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
    } catch (_) {
      yield RemoteClientErrorState();
      return;
    }
  }

  Stream<BlogDetailsState> _mapDownloadFileToState(
    DownloadFileEvent event,
  ) async* {
    try {
      GlobalPurposeFunctions.downloadFile(event.url, event.fileName);
    } catch (_) {
      yield RemoteClientErrorState();
      return;
    }
  }
}
