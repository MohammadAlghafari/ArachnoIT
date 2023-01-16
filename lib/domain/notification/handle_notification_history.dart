import 'dart:convert';

import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/notification/response/get_notification_response.dart';
import 'package:arachnoit/presentation/screens/active_session/active_session.dart';
import 'package:arachnoit/presentation/screens/blog_details/blog_details_screen.dart';
import 'package:arachnoit/presentation/screens/blogs_details_replay/blogs_detail_replay_screen.dart';
import 'package:arachnoit/presentation/screens/group_details/group_details_screen.dart';
import 'package:arachnoit/presentation/screens/question_details/question_details_screen.dart';
import 'package:arachnoit/presentation/screens/question_details_replay/question_detail_replay_screen.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class HandleNotificationHistory {
  String title;
  String description;
  Function function;
  // ignore: missing_return
  factory HandleNotificationHistory(
      {@required PersonNotification requestData, @required BuildContext context}) {
    if (requestData.notificationType == "AnswerOnMyQuestion" ||
        requestData.notificationType == "QuestionEmphasis" ||
        requestData.notificationType == "FollowingNewQuestion" ||
        requestData.notificationType == "FollowingNewAnswer")
      return HandleNotificationHistory.moveToQuestionScreen(requestData, context);
    else if (requestData.notificationType == "BlogEmphasis" ||
        requestData.notificationType == "CommentOnMyblog" ||
        requestData.notificationType == "FollowingNewBlog" ||
        requestData.notificationType == "FollowingNewComment") {
      return HandleNotificationHistory.moveToBlogScreen(requestData, context);
    } else if (requestData.notificationType == "ApproveToJoinGroup" ||
        requestData.notificationType == "JoinInGroup") {
      return HandleNotificationHistory.moveToGroupScreen(requestData, context);
    } else if (requestData.notificationType == "UserLogin") {
      return HandleNotificationHistory.moveToActiveSession(requestData, context);
    } else if (requestData.notificationType == "CommentOnMyAnswer") {
      return HandleNotificationHistory.moveToMyReplayQuestionDetail(requestData, context);
    } else if (requestData.notificationType == "ReplyOnMyComment") {
      return HandleNotificationHistory.moveToMyReplayBlogDetail(requestData, context);
    } else {
      return HandleNotificationHistory.hanlde(requestData, context);
    }
  }

  String getTheTitle(PersonNotification personNotification, BuildContext context) {
    String title = "";

    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);

    if (requestDataMapItem['Title'][0] != '{') {
      title = requestDataMapItem['Title'];
    } else {
      if (Localizations.localeOf(context).toString() == 'ar') {
        title = jsonDecode(requestDataMapItem['Title'])['ar-SY'];
      } else {
        title = jsonDecode(requestDataMapItem['Title'])['en-US'];
      }
    }
    return title;
  }

  HandleNotificationHistory.moveToMyReplayBlogDetail(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem['Body'] ?? "";
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

  HandleNotificationHistory.moveToMyReplayQuestionDetail(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem['Body'] ?? "";
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

  HandleNotificationHistory.moveToBlogScreen(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem['Body'] ?? "";
    function = () {
      print("The type is ${personNotification.notificationType}");
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

  HandleNotificationHistory.moveToQuestionScreen(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);

    title = getTheTitle(personNotification, context);

    description = requestDataMapItem['Body'] ?? "";
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

  HandleNotificationHistory.moveToGroupScreen(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem['Body'] ?? "";
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

  HandleNotificationHistory.moveToActiveSession(
      PersonNotification personNotification, BuildContext context) {
    Map<String, dynamic> requestDataMapItem = jsonDecode(personNotification.requestData);
    title = getTheTitle(personNotification, context);
    description = requestDataMapItem['Body'] ?? "";
    function = () async {
      print("The type is ${personNotification.notificationType}");
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

  HandleNotificationHistory.hanlde(PersonNotification requestData, BuildContext context) {
    title = "aaa";
    description = "aa";
    function = () {};
  }
}
