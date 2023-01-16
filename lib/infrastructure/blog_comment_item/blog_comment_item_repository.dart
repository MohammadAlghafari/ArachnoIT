import 'package:arachnoit/infrastructure/blog_comment_item/caller/get_profile_brief.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/vote_response.dart';
import 'blog_comment_item_interface.dart';
import 'caller/set_useful_vote_for_blog_comment_remote_data_provider.dart';

class CommentItemRepository implements BlogCommentItemInterface {
  CommentItemRepository(
      {this.setUsefulVoteForCommentRemoteDataProvider,
      @required this.getCommentProfileBrife});

  final GetCommentProfileBrife getCommentProfileBrife;

  final SetUsefulVoteForCommentRemoteDataProvider
      setUsefulVoteForCommentRemoteDataProvider;
  @override
  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForComment(
      {String itemId, bool status}) async {
    try {
      Response response = await setUsefulVoteForCommentRemoteDataProvider.setUsefulVoteForComment(
        itemId: itemId,
        status: status,
      );
      return _prepareSetVoteResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
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

  @override
  Future<ResponseWrapper<BriefProfileResponse>> getBriefProfile(
      {String id}) async {
    try {
      Response response =
          await getCommentProfileBrife.getProfileBriefInfo(id: id);
      return _prepareGetBriefProfile(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<BriefProfileResponse> _prepareGetBriefProfile(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<BriefProfileResponse>();
    if (remoteResponse != null) {
      res.data = BriefProfileResponse.fromJson(remoteResponse.data);
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
}
