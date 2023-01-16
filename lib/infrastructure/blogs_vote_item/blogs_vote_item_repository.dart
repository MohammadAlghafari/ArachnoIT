import 'package:arachnoit/infrastructure/api/response_wrapper.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'blogs_vote_item_interface.dart';
import 'call/get_blogs_vote_item_profile_brife.dart';
import '../api/response_type.dart' as ResType;

class BlogsVoteItemRepository implements BlogsVoteItemInterface{
  GetBlogsVoteItemProfileBrife getBlogsVoteItemProfileBrife;
  BlogsVoteItemRepository({this.getBlogsVoteItemProfileBrife});
 @override
  Future<ResponseWrapper<BriefProfileResponse>> getBriefProfile(
      {String id}) async {
    try {
      Response response =
          await getBlogsVoteItemProfileBrife.getProfileBriefInfo(id: id);
      return _prepareGetBriefProfile(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetBriefProfile(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetBriefProfile(
        remoteResponse: null,
      );
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