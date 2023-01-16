import 'package:arachnoit/infrastructure/blog_details/caller/add_comment.dart';
import 'package:arachnoit/infrastructure/blog_details/caller/delete_comment.dart';
import 'package:arachnoit/infrastructure/blog_comment_item/caller/get_profile_brief.dart';
import 'package:arachnoit/infrastructure/blog_details/caller/report_comment.dart';
import 'package:arachnoit/infrastructure/blog_details/caller/update_comment.dart';
import 'package:arachnoit/infrastructure/blog_details/response/comment_body_respose.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/vote_response.dart';
import 'blog_details_interface.dart';
import 'caller/get_blog_details_remote_data_provider.dart';
import 'caller/set_emphasis_vote_for_blog_details_remote_data_provider.dart';
import 'caller/set_useful_vote_for_blog_details_remote_data_provider.dart';
import 'response/blog_details_response.dart';

class BlogDetailsRepository implements BlogDetailsInterface {
  final DeleteComment deleteComment;
  final UpdatComment updatComment;
  final AddComment addComment;
  final SendCommentReport sendCommentReport;
  BlogDetailsRepository(
      {this.getBlogDetailsRemoteDataProvider,
      this.setUsefulVoteForBlogDetailsRemoteDataProvider,
      this.setEmphasisVoteForBlogDetailsRemoteDataProvider,
      @required this.addComment,
      @required this.updatComment,
      @required this.deleteComment,
      @required this.sendCommentReport});
  final GetBlogDetailsRemoteDataProvider getBlogDetailsRemoteDataProvider;
  final SetUsefulVoteForBlogDetailsRemoteDataProvider
      setUsefulVoteForBlogDetailsRemoteDataProvider;
  final SetEmphasisVoteForBlogDetailsRemoteDataProvider
      setEmphasisVoteForBlogDetailsRemoteDataProvider;
  @override
  Future<ResponseWrapper<BlogDetailsResponse>> getBlogDetails(
      {String blogId}) async {
    try {
      Response response = await getBlogDetailsRemoteDataProvider.getBlogDetails(
        blogId: blogId,
      );
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

  @override
  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForBlogDetails({
    @required String itemId,
    @required bool status,
  }) async {
    try {
      Response response = await setUsefulVoteForBlogDetailsRemoteDataProvider
          .setUsefulVoteForBlogDetails(
        itemId: itemId,
        status: status,
      );
      return _prepareSetVoteResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSetVoteResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareSetVoteResponse(
        remoteResponse: null,
      );
    }
  }

  @override
  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForBlogDetails({
    @required String itemId,
    @required bool status,
  }) async {
    try {
      Response response = await setEmphasisVoteForBlogDetailsRemoteDataProvider
          .setEmphasisVoteForBlogDetails(
        itemId: itemId,
        status: status,
      );
      return _prepareSetEmphasisResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSetEmphasisResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareSetEmphasisResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<VoteResponse> _prepareSetEmphasisResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<VoteResponse>();
    if (remoteResponse != null) {
      res.data = VoteResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
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

  ResponseWrapper<VoteResponse> _prepareSetVoteResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<VoteResponse>();
    if (remoteResponse != null) {
      res.data = VoteResponse.fromMap(remoteResponse.data[AppConst.ENTITY]);
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

  ResponseWrapper<BlogDetailsResponse> _prepareBlogDetailsResponse(
      {@required Response<dynamic> remoteResponse}) {

    var res = ResponseWrapper<BlogDetailsResponse>();
    if (remoteResponse != null ) {
      print(remoteResponse.statusCode);
      if(remoteResponse.statusCode==200)
      res.data = BlogDetailsResponse.fromMap(remoteResponse.data);
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
  Future<ResponseWrapper<CommentBodyRespose>> setNewComment(
      {String comment, String postId, String commentId}) async {
    try {
      Response response =
          await addComment.addNewComment(message: comment, postId: postId);
      return _preparesetNewComment(remoteResponse: response);
    } on DioError catch (e) {
      return _preparesetNewComment(remoteResponse: e.response.data);
    } catch (e) {
      return _preparesetNewComment(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<CommentBodyRespose> _preparesetNewComment(
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
  Future<ResponseWrapper<CommentBodyRespose>> updateComment(
      {String comment, String postId, String commentId}) async {
    try {
      Response response = await updatComment.updateSelectedComment(
          message: comment, postId: postId, commentId: commentId);
      return _preparesetUpdateComment(remoteResponse: response);
    } on DioError catch (e) {
      print("the errors is $e");

      return _preparesetUpdateComment(remoteResponse: e.response.data);
    } catch (e) {
      print("the errors is $e");
      return _preparesetUpdateComment(remoteResponse: e.request.data);
    }
  }

  ResponseWrapper<CommentBodyRespose> _preparesetUpdateComment(
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
  Future<ResponseWrapper<bool>> deleteSelectedComment(
      {String commentId}) async {
    try {
      Response response =
          await deleteComment.deleteComment(commentId: commentId);
      return _preparesetDeleteSelectedComment(remoteResponse: response);
    } on DioError catch (e) {
      return _preparesetDeleteSelectedComment(remoteResponse: e.response.data);
    } catch (e) {
      return _preparesetDeleteSelectedComment(remoteResponse: e.request.data);
    }
  }



  ResponseWrapper<bool> _preparesetDeleteSelectedComment(
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
  Future<ResponseWrapper<bool>> sendReport(
      {String commentId, String description}) async {
    try {
      Response response = await sendCommentReport.sendReport(
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
