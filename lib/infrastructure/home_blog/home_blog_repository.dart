import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/infrastructure/home_blog/caller/report_blogs.dart';
import 'package:arachnoit/infrastructure/common_response/vote_response.dart';
import 'package:arachnoit/infrastructure/home_blog/caller/get_profile_brief.dart';
import 'package:arachnoit/infrastructure/home_blog/caller/set_emphasis_vote_for_blog_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/home_blog/caller/set_useful_vote_for_blog_remote_data_provider.dart';
import 'package:arachnoit/infrastructure/common_response/brief_profile_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import 'caller/delete_blog.dart';
import 'caller/get_blogs_local_data_provider.dart';
import 'caller/get_blogs_remote_data_provide.dart';
import 'home_blog_interface.dart';
import 'response/get_blogs_response.dart';

class HomeBlogRepository implements HomeBlogInterface {
  HomeBlogRepository({
    @required this.getBlogsLocalDataProvider,
    @required this.getBlogsRemoteDataProvider,
    @required this.setEmphasisVoteForBlogRemoteDataProvider,
    @required this.setUsefulVoteForBlogRemoteDataProvider,
    @required this.getProfileBrife,
    @required this.reportBlogs,
    @required this.deleteSelectedBlogs,
  });
  final DeleteSelectedBlogs deleteSelectedBlogs;
  final GetBlogsLocalDataProvider getBlogsLocalDataProvider;
  final GetBlogsRemoteDataProvider getBlogsRemoteDataProvider;
  final SetEmphasisVoteForBlogRemoteDataProvider
      setEmphasisVoteForBlogRemoteDataProvider;
  final SetUsefulVoteForBlogRemoteDataProvider
      setUsefulVoteForBlogRemoteDataProvider;
  final GetProfileBrife getProfileBrife;
  final ReportBlogs reportBlogs;

  @override
  Future<ResponseWrapper<List<GetBlogsResponse>>> getBlogs({
    @required String personId,
    @required int accountTypeId,
    @required String blogId,
    @required String categoryId,
    @required String subCategoryId,
    @required String groupId,
    @required bool myFeed,
    @required List<String> tagsId,
    @required String query,
    @required bool isResearcher,
    @required int pageNumber,
    @required int pageSize,
    @required int orderByBlogs,
    @required bool mySubscriptionsOnly,
  }) async {
    try {
      Response response = await getBlogsRemoteDataProvider.getBlogs(
        personId: personId,
        accountTypeId: accountTypeId,
        blogId: blogId,
        categoryId: categoryId,
        subCategoryId: subCategoryId,
        groupId: groupId,
        myFeed: myFeed,
        tagsId: tagsId,
        query: query,
        isResearcher: isResearcher,
        pageNumber: pageNumber,
        pageSize: pageSize,
        orderByBlogs: orderByBlogs,
        mySubscriptionsOnly: mySubscriptionsOnly,
      );
      return _prepareGetBlogsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareGetBlogsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareGetBlogsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<GetBlogsResponse>> _prepareGetBlogsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<GetBlogsResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data as List)
          .map((x) => GetBlogsResponse.fromMap(x))
          .toList();
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
  Future<ResponseWrapper<VoteResponse>> setEmphasisVoteForBlog({
    @required String itemId,
    @required bool status,
  }) async {
    try {
      Response response =
          await setEmphasisVoteForBlogRemoteDataProvider.setEmphasisVoteForBlog(
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

  @override
  Future<ResponseWrapper<VoteResponse>> setUsefulVoteForBlog({
    @required String itemId,
    @required bool status,
  }) async {
    try {
      Response response =
          await setUsefulVoteForBlogRemoteDataProvider.setUsefulVoteForBlog(
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
      Response response = await getProfileBrife.getProfileBriefInfo(id: id);
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

  @override
  Future<ResponseWrapper<bool>> sendBlogsReport(
      {String blogID, String description}) async {
    try {
      Response response = await reportBlogs.sendReport(
          blogID: blogID, description: description);
      return _prepareSendBlogsReport(remoteResponse: response);
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<bool> _prepareSendBlogsReport(
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
  Future<ResponseWrapper<bool>> deleteBlog({String blogID}) async {
    try {
      Response response = await deleteSelectedBlogs.deletBlog(blogId: blogID);
      return _prepareDeleteBlog(remoteResponse: response);
    } on DioError catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  ResponseWrapper<bool> _prepareDeleteBlog(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<bool>();
    if (remoteResponse != null) {
      if (remoteResponse.statusCode == 200) {
        res.data = true;
      } else {
        res.data = false;
      }
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
