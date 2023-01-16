import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/blog_replay_comment_item_interface.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/caller/add_replay.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/caller/delete_replay.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/caller/get_blogs_details.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/caller/report_replay.dart';
import 'package:arachnoit/infrastructure/blog_replay_detail/caller/update_replay.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:flutter/cupertino.dart';
import '../api/response_type.dart' as ResType;
import 'package:dio/dio.dart';

import '../home_blog/caller/report_blogs.dart';

class BlogReplayDetailRepository implements BlogReplayDetailInterface {
  final AddReplay addReplay;
  final UpdateCommentReplay updateReplay;
  final DeleteCommentReplay deleteReplay;
  final GetBlogsDetail getBlogsDetail;
  final SendReplayReport sendReplayReport;
  BlogReplayDetailRepository({
    @required this.addReplay,
    @required this.updateReplay,
    @required this.deleteReplay,
    @required this.getBlogsDetail,
    @required this.sendReplayReport,
  });
  @override
  Future<ResponseWrapper<bool>> deleteSelectedReplay({String commentId}) async {
    try {
      Response response =
          await deleteReplay.deleteSelectedReplay(commentId: commentId);
      return _prepareDeleteSelectedReplay(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareDeleteSelectedReplay(remoteResponse: e.response.data);
    } catch (e) {
      return _prepareDeleteSelectedReplay(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<bool> _prepareDeleteSelectedReplay(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<CommentBodyRespose>> setNewRaplay(
      {String comment, String postId}) async {
    try {
      Response response =
          await addReplay.addNewReplay(message: comment, postId: postId);
      return _prepareSetNewReplay(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSetNewReplay(remoteResponse: e.response.data);
    } catch (e) {
      return _prepareSetNewReplay(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<CommentBodyRespose> _prepareSetNewReplay(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<CommentBodyRespose>();
    if (remoteResponse != null) {
      res.data =
          CommentBodyRespose.fromJson(remoteResponse.data[AppConst.ENTITY]);
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<CommentBodyRespose>> updateSeletedReplay(
      {String comment, String postId, String commentId}) async {
    try {
      Response response = await updateReplay.updateSelectedReplay(
          message: comment, postId: postId, commentId: commentId);
      return _prepareUpdateReplay(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareUpdateReplay(remoteResponse: e.response.data);
    } catch (e) {
      return _prepareUpdateReplay(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<CommentBodyRespose> _prepareUpdateReplay(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<CommentBodyRespose>();
    if (remoteResponse != null) {
      res.data = CommentBodyRespose.fromJson(remoteResponse.data);
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<CommentResponse>> getCommentReplay(
      {String commentId}) async {
    try {
      Response response =
          await getBlogsDetail.getCommentReplay(commentId: commentId);
      return _prepareBlogDetailsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareBlogDetailsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareBlogDetailsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<CommentResponse> _prepareBlogDetailsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<CommentResponse>();
    if (remoteResponse != null) {
      res.data = CommentResponse.fromMap(remoteResponse.data);
      res.enumResult = null;
      res.errorMessage = null;
      res.successEnum = null;
      res.successMessage = null;
      res.opertationName = null;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }

  @override
  Future<ResponseWrapper<bool>> sendReport(
      {String commentId, String description}) async {
    try {
      Response response = await sendReplayReport.sendReport(
          commentId: commentId, description: description);
      return _prepareSendReport(remoteResponse: response);
    } on DioError catch (e) {
      return _prepareSendReport(remoteResponse: e.response);
    } catch (e) {
      return _prepareSendReport(remoteResponse: null);
    }
  }

  ResponseWrapper<bool> _prepareSendReport(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
      res.enumResult = remoteResponse.data[AppConst.ENUM_RESULT] as int;
      res.errorMessage = remoteResponse.data[AppConst.ERROR_MESSAGES] as String;
      res.successEnum = remoteResponse.data[AppConst.SUCCESS_ENUM] as int;
      res.successMessage =
          remoteResponse.data[AppConst.SUCCESS_MESSAGE] as String;
      res.opertationName =
          remoteResponse.data[AppConst.OPERATON_NAME] as String;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}