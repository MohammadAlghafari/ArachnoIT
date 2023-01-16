import 'dart:async';
import 'dart:convert';

import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/blog_details/response/blog_details_response.dart';
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/catalog_facade_service.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_reply_response.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
part 'blog_replay_comment_item_event.dart';
part 'blog_replay_comment_item_state.dart';

class BlogReplayDetailBloc
    extends Bloc<BlogReplayDetailEvent, BlogReplayDetailState> {
  CatalogFacadeService catalogService;
  BlogReplayDetailBloc({this.catalogService})
      : super(BlogReplayCommentItemInitial());

  @override
  Stream<BlogReplayDetailState> mapEventToState(
      BlogReplayDetailEvent event) async* {
    if (event is AddNewReplay) {
      yield* _mapAddNewReplay(event);
    } else if (event is UpdateReplay) {
      yield* _mapUpdateReplay(event);
    } else if (event is DeleteReplay) {
      yield* _mapDeleteReplay(event);
    } else if (event is FetchAllComment) {
      yield* _mapFetchBlogDetailsToState(event);
    } else if (event is IsUpdateClickEvent)
      yield IsUpdateClickState(state: event.state);
    else if (event is SendReport) {
      yield* _mapSendReport(event);
    }
  }

  Stream<BlogReplayDetailState> _mapSendReport(SendReport event) async* {
    try {
      ResponseWrapper<bool> res = await catalogService.sendReplayReport(
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

  Stream<BlogReplayDetailState> _mapFetchBlogDetailsToState(
    FetchAllComment event,
  ) async* {
    if(!event.isRefreshData)
    yield LoadingState();
    try {
      final ResponseWrapper<CommentResponse> blogDetailsResponse =
          await catalogService.getCommentReplay(
        commentId: event.commentId,
      );
      switch (blogDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield SuccessGetAllComments(comment: blogDetailsResponse.data);
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
      }
    } on Exception catch (_) {}
  }

  Stream<BlogReplayDetailState> _mapAddNewReplay(AddNewReplay event) async* {
    try {
      print("the id is ${event.postId}");
      ResponseWrapper<CommentBodyRespose> responseWrapper =
          await catalogService.addNewReplay(
        comment: event.comment,
        postId: event.postId,
      );
      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        LoginResponse userInfo = LoginResponse.fromMap(
            json.decode(prefs.get(PrefsKeys.LOGIN_RESPONSE)));
        CommentReplyResponse blogCommentReplyRespons =
            new CommentReplyResponse(
                body: responseWrapper.data.body,
                id: responseWrapper.data.id,
                creationDate: formattedDate,
                firstName: userInfo.firstName,
                lastName: userInfo.lastName,
                inTouchPointName: userInfo.inTouchPointName,
                personId: userInfo.userId,
                photoUrl: userInfo.photoUrl,
                isHealthcareProvider: false);
        yield SuccessAddReplay(
            blogCommentReplyResponse: blogCommentReplyRespons);
        return;
      } else {
        yield ErrorState(errorMessage: responseWrapper.errorMessage);
        return;
      }
    } on DioError catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
      return;
    } catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
      return;
    }
  }

  Stream<BlogReplayDetailState> _mapUpdateReplay(UpdateReplay event) async* {
    try {
      ResponseWrapper<CommentBodyRespose> responseWrapper =
          await catalogService.updateCommentReplay(
              commentId: event.commentId,
              postId: event.postId,
              comment: event.comment);
      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
        {
          yield SuccessUpdateReplay(index: event.selectCommentIndex);
          return;
        }
      }
    } catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
    }
  }

  Stream<BlogReplayDetailState> _mapDeleteReplay(DeleteReplay event) async* {
    try {
      ResponseWrapper<bool> responseWrapper =
          await catalogService.deleteCommentReplay(commentId: event.commentId);
      if (responseWrapper.responseType == ResType.ResponseType.SUCCESS) {
        {
          yield SuccessDeleteReplay(index: event.selectCommentIndex);
          return;
        }
      }
    } catch (e) {
      yield ErrorState(errorMessage: "Error Happened Try Again");
    }
  }
}
