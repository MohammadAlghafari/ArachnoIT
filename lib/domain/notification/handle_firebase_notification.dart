import 'dart:convert';

import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/notification/response/get_notification_response.dart';
import 'package:arachnoit/presentation/screens/active_session/active_session.dart';
import 'package:arachnoit/presentation/screens/blog_details/blog_details_screen.dart';
import 'package:arachnoit/presentation/screens/blogs_details_replay/blogs_detail_replay_screen.dart';
import 'package:arachnoit/presentation/screens/group_details/group_details_screen.dart';
import 'package:arachnoit/presentation/screens/question_details/question_details_screen.dart';
import 'package:arachnoit/presentation/screens/question_details_replay/question_detail_replay_screen.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class HandleFirebaseNotification {
  String title;
  String description;
  Function function;
  RemoteMessage remoteMessage;
  // ignore: missing_return
  factory HandleFirebaseNotification(
      {@required PersonNotification requestData,
      @required BuildContext context,
      RemoteMessage remoteMessage}) {
    int notificationType = int.parse(remoteMessage.data['notificationType']);

    if (notificationType == AppConst.ANSWER_ON_MY_QUESTION ||
        notificationType == AppConst.QUESTION_EMPHASIS ||
        notificationType == AppConst.FOLLOWING_NEW_QUESTION ||
        notificationType == AppConst.FOLLOWING_NEW_ANSWER ||
        notificationType == AppConst.ANSWER_EMPHASIS ||
        notificationType == AppConst.CATEGORY_NEW_QUESTION) {
      return HandleFirebaseNotification.moveToQuestionScreen(requestData, context);
    } else if (AppConst.BLOG_EMPHASIS == notificationType ||
        AppConst.COMMENT_ON_MY_BLOG == notificationType ||
        AppConst.FOLLOWING_NEW_BLOG == notificationType ||
        AppConst.FOLLOWING_NEW_COMMENT == notificationType ||
        AppConst.CATEGORY_NEW_BLOG == notificationType ||
        AppConst.SUB_CATEGORY_NEW_BLOG == notificationType) {
      return HandleFirebaseNotification.moveToBlogScreen(requestData, context);
    } else if (AppConst.APPROVE_TO_JOIN_GROUP == notificationType ||
        AppConst.JOIN_IN_GROUP == notificationType) {
      return HandleFirebaseNotification.moveToGroupScreen(requestData, context);
    } else if (AppConst.USER_LOGIN == notificationType) {
      return HandleFirebaseNotification.moveToActiveSession(requestData, context);
    } else if (AppConst.COMMENT_ON_MY_ANSWER == notificationType ||
        AppConst.COMMENT_ON_MY_ANSWER == notificationType ||
        AppConst.FOLLOWING_NEW_ANSWER == notificationType) {
      return HandleFirebaseNotification.moveToMyReplayQuestionDetail(requestData, context);
    } else if (AppConst.REPLY_ON_MY_COMMENT == notificationType ||
        AppConst.COMMENT_ON_MY_ANSWER == notificationType ||
        AppConst.FOLLOWING_NEW_COMMENT == notificationType) {
      return HandleFirebaseNotification.moveToMyReplayBlogDetail(requestData, context);
    } else if (AppConst.NEW_FOLLOW == notificationType) {
      return HandleFirebaseNotification.moveToUserProfile(requestData, context);
    } else {
      return HandleFirebaseNotification.hanlde(requestData, context);
    }
  }

  String getTheTitle(PersonNotification personNotification, BuildContext context) {
    String title = "";

    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);

    if (requestDataMapItem[AppConst.TITLE][0] != '{') {
      title = requestDataMapItem[AppConst.TITLE];
    } else {
      if (Localizations.localeOf(context).toString() == 'ar') {
        title = jsonDecode(requestDataMapItem[AppConst.TITLE])['ar-SY'];
      } else {
        title = jsonDecode(requestDataMapItem[AppConst.TITLE])['en-US'];
      }
    }
    return title;
  }

  HandleFirebaseNotification.moveToUserProfile(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem[AppConst.BODY] ?? "";
    function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlogsDetailReplayScreen(
            commentId: requestDataMapItem['CommentId'] ?? "",
            userInfo: GlobalPurposeFunctions.getUserObject(),
          ),
        ),
      );
    };
  }

  HandleFirebaseNotification.moveToMyReplayBlogDetail(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem[AppConst.BODY] ?? "";
    function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlogsDetailReplayScreen(
            commentId: requestDataMapItem['CommentId'] ?? "",
            userInfo: GlobalPurposeFunctions.getUserObject(),
          ),
        ),
      );
    };
  }

  HandleFirebaseNotification.moveToMyReplayQuestionDetail(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem[AppConst.BODY] ?? "";
    function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionDetailReplayScreen(
            answerId: requestDataMapItem['AnswerId'] ?? "",
            questionId: requestDataMapItem['QuestionId'] ?? "",
            userInfo: GlobalPurposeFunctions.getUserObject(),
          ),
        ),
      );
    };
  }

  HandleFirebaseNotification.moveToBlogScreen(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem[AppConst.BODY] ?? "";
    function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlogDetailsScreen(
            blogId: requestDataMapItem['BlogId'] ?? "",
            userId: GlobalPurposeFunctions.getUserObject().userId,
          ),
        ),
      );
    };
  }

  HandleFirebaseNotification.moveToQuestionScreen(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);

    title = getTheTitle(personNotification, context);

    description = requestDataMapItem[AppConst.BODY] ?? "";
    function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionDetailsScreen(
            questionId: requestDataMapItem['QuestionId'] ?? "",
            userInfo: GlobalPurposeFunctions.getUserObject(),
          ),
        ),
      );
    };
  }

  HandleFirebaseNotification.moveToGroupScreen(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem[AppConst.BODY] ?? "";
    function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupDetailsScreen(
            groupId: requestDataMapItem['ItemId'] ?? "",
          ),
        ),
      );
    };
  }

  HandleFirebaseNotification.moveToActiveSession(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem[AppConst.BODY] ?? "";
    function = () async {
      AndroidDeviceInfo mobileInfo = await GlobalPurposeFunctions.initPlatformState();
      String wifiIP = await GlobalPurposeFunctions.getIpAddress();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ActiveSession(
            mobileInfo: mobileInfo,
            wifiIP: wifiIP,
          ),
        ),
      );
    };
  }

  HandleFirebaseNotification.hanlde(PersonNotification requestData, BuildContext context) {
    title = "aaa";
    description = "aa";
    function = () {};
  }
}
