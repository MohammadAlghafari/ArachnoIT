import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:arachnoit/application/latest_version/latest_version_bloc.dart';
import 'package:arachnoit/application/main/main_bloc.dart';
import 'package:arachnoit/domain/common/social_register.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question.dart';
import 'package:arachnoit/presentation/screens/latest_apk/latest_apk_screen.dart';
import 'package:arachnoit/presentation/screens/splash/splash.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:arachnoit/common/app_const.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/screens/add_blog/add_blog_screen.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question_screen.dart';
import 'package:arachnoit/presentation/screens/group_details/group_details_screen.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/normal_user_personal_info_screen.dart/normal_user_personal_info.dart';
import 'package:arachnoit/presentation/screens/profile_normal_user.dart/profile_normal_user.dart/profile_normal_user.dart';
import 'package:arachnoit/presentation/screens/profile_provider/profile_provider/profile_provider_screen.dart';
import 'package:arachnoit/presentation/screens/profile_provider/qualifications/add_catagory_item_screen.dart';
import 'package:arachnoit/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'application/notification_provider/notification_bloc.dart';
import 'common/app_const.dart';
import 'common/pref_keys.dart';
import 'infrastructure/catalog_facade_service.dart';
import 'infrastructure/home_blog/response/get_blogs_response.dart';
import 'infrastructure/login/response/login_response.dart';
import 'injections.dart' as di;
import 'injections.dart';
import 'presentation/custom_widgets/restart_widget.dart';
import 'presentation/screens/about_arachno_in_touch/about_arachno_in_touch_screen.dart';
import 'presentation/screens/all_public_groups/all_public_groups_screen.dart';
import 'presentation/screens/blog_details/blog_details_screen.dart';
import 'presentation/screens/change_password/change_password_screen.dart';
import 'presentation/screens/discover_Categories_sub_category_all_groups/discover_categories_sub_category_all_groups_screen.dart';
import 'presentation/screens/discover_categories_details/discover_categories_details_screen.dart';
import 'presentation/screens/discover_categories_sub_category_all_blogs/discover_categories_sub_category_all_blogs_screen.dart';
import 'presentation/screens/discover_categories_sub_category_all_questions/discover_categories_sub_category_all_questions_screen.dart';
import 'presentation/screens/forgetPassword/forget_password_screen.dart';
import 'presentation/screens/group_add/group_add_screen.dart';
import 'presentation/screens/group_details/group_details_screen.dart';
import 'presentation/screens/group_details_info/group_details_info_screen.dart';
import 'presentation/screens/group_details_search/group_details_serach_screen.dart';
import 'presentation/screens/group_members_provider/home_gruop_memebers_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/main/main_screen.dart';
import 'presentation/screens/photo_view/photo_view_screen.dart';
import 'presentation/screens/question_details/question_details_screen.dart';
import 'presentation/screens/registraition/register_business_user_screen.dart';
import 'presentation/screens/registraition/register_individual_user_screen.dart';
import 'presentation/screens/registraition/register_normal_user_screen.dart';
import 'presentation/screens/registraition/registration_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/single_photo_view/single_photo_view_screen.dart';
import 'presentation/screens/userManual/user_manual_screen.dart';
import 'presentation/screens/verification/verification_screen.dart';
import 'package:arachnoit/common/app_const.dart';

GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

int count = 0;
String userId = "";
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  sendNotification(message);
}

void sendNotification(RemoteMessage remoteMessage) {
  int notificationType = int.parse(remoteMessage.data['notificationType']);
  switch (notificationType) {
    case AppConst.NEW_FOLLOW:
      handleNewFollowNotification(remoteMessage); //done
      break;

    case AppConst.APPROVE_TO_JOIN_DPARTMENT:
      handleApproveToJoinDepartmentNotification(remoteMessage); //done
      break;

    case AppConst.APPROVE_TO_JOIN_PATENT:
      handleApproveToJoinPatentNotification(remoteMessage); //done
      break;

    case AppConst.ANSWER_EMPHASIS:
      handleAnswerEmphasisNotification(remoteMessage); //done
      break;

    case AppConst.ANSWER_ON_MY_QUESTION:
      handleAnswerOnMyQuestionNotification(remoteMessage); //done
      break;

    case AppConst.CATEGORY_NEW_QUESTION:
      handleCategoryNewQuestionNotification(remoteMessage); //done
      break;

    case AppConst.COMMENT_ON_MY_ANSWER:
      handleCommentOnMyAnswerNotification(remoteMessage); //done
      break;

    case AppConst.FOLLOWING_NEW_ANSWER:
      handleFollowingNewAnswerNotification(remoteMessage); //done
      break;

    case AppConst.FOLLOWING_NEW_QUESTION:
      handleFollowingNewQuestionNotification(remoteMessage); //done
      break;

    case AppConst.QUESTION_EMPHASIS:
      handleQuestionEmphasisNotification(remoteMessage); //done
      break;

    case AppConst.SUB_CATEGORY_NEW_QUESTION:
      handleSubCategoryNewQuestionNotification(remoteMessage); //done
      break;

    case AppConst.COMMENT_ON_MY_BLOG:
      handleCommentOnMyBlogNotification(remoteMessage); //done
      break;

    case AppConst.REPLY_ON_MY_COMMENT:
      handleReplyOnMyCommentNotification(remoteMessage); //done
      break;

    case AppConst.BLOG_EMPHASIS:
      handleBlogEmphasisNotification(remoteMessage); //done
      break;

    case AppConst.COMMENT_EMPHASIS:
      handleCommentEmphasisNotification(remoteMessage); //done
      break;

    case AppConst.FOLLOWING_NEW_BLOG:
      handleFollowingNewBlogNotification(remoteMessage); //done
      break;

    case AppConst.FOLLOWING_NEW_COMMENT:
      handleFollowingNewCommentNotification(remoteMessage); //done
      break;

    case AppConst.CATEGORY_NEW_BLOG:
      handleCategoryNewBlogNotification(remoteMessage); //done
      break;

    case AppConst.SUB_CATEGORY_NEW_BLOG:
      handleSubCategoryNewBlogNotification(remoteMessage); //done
      break;

    case AppConst.FOLLOWING_NEW_RESEARCH:
      handleFollowingNewResearchNotification(remoteMessage); //done
      break;

    case AppConst.APPROVE_TO_JOIN_GROUP:
      handleApproveToJoinGroupNotification(remoteMessage); //done
      break;

    // case AppConst.NEW_MESSAGE:
    //   handleNewMessageNotification(remoteMessage);
    //   break;

    case AppConst.JOIN_IN_GROUP:
      handleJoinGroupNotification(remoteMessage);
      break;

    case AppConst.REQUEST_GROUP_MEMBER_TO_JOIN:
      handleRequestGroupMemberToJoinNotification(remoteMessage);
      break;

    case AppConst.USER_LOGIN:
      handleUserLoginNotification(remoteMessage);
      break;
  }
}

void handleNewFollowNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isFollowingAllowed = PreferenceManager.getInstance()
  //     .getBoolean(AppConst.FOLLOWING_NOTIFICATION, true);
  // if (isFollowingAllowed)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleApproveToJoinDepartmentNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleApproveToJoinPatentNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleAnswerEmphasisNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleAnswerOnMyQuestionNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleCategoryNewQuestionNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  // titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  // title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  // title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isQnaMuted = PreferenceManager.getInstance().getBoolean(AppConst.MUTE_QNA, true);
  // if (!isQnaMuted)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleCommentOnMyAnswerNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleFollowingNewAnswerNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  // titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  // title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  // title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isQnaFollowingAllowed = PreferenceManager.getInstance().getBoolean(AppConst.QNA_FOLLOWING_NOTIFICATION, true);
  // if (isQnaFollowingAllowed)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleFollowingNewQuestionNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  // titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  // title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  // title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isQnaFollowingAllowed = PreferenceManager.getInstance().getBoolean(AppConst.QNA_FOLLOWING_NOTIFICATION, true);
  // if (isQnaFollowingAllowed)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleQuestionEmphasisNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleSubCategoryNewQuestionNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  // titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  // title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  // title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isQnaMuted = PreferenceManager.getInstance().getBoolean(AppConst.MUTE_QNA, true);
  // if (!isQnaMuted)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleCommentOnMyBlogNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleReplyOnMyCommentNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleBlogEmphasisNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleCommentEmphasisNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleFollowingNewBlogNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  // titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  // title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  // title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isCommunicationFollowingAllowed = PreferenceManager.getInstance().getBoolean(AppConst.COMMUNICATION_FOLLOWING_NOTIFICATION, true);
  // if (isCommunicationFollowingAllowed)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleFollowingNewCommentNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  // titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  // title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  // title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isCommunicationFollowingAllowed = PreferenceManager.getInstance().getBoolean(AppConst.COMMUNICATION_FOLLOWING_NOTIFICATION, true);
  // if (isCommunicationFollowingAllowed)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleCategoryNewBlogNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  //     titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  //     title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  //     title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isCommunicationMuted = PreferenceManager.getInstance().getBoolean(AppConst.MUTE_COMMUNICATION, true);
  // if (!isCommunicationMuted)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleSubCategoryNewBlogNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  //     titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  //     title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  //     title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  // boolean isCommunicationMuted = PreferenceManager.getInstance().getBoolean(AppConst.MUTE_COMMUNICATION, true);
  // if (!isCommunicationMuted)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleFollowingNewResearchNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  // if (title != null) {
  // titleArray = title.split(",");
  // }
  // if (PreferenceManager.getInstance().getString(AppConst.APP_LANG, AppConst.ENGLISH_CULTURE_CODE).equals(AppConst.ARABIC_CULTURE_CODE)) {
  // title = titleArray[0].substring(10, titleArray[0].length() - 1);
  // } else {
  // title = titleArray[1].substring(9, titleArray[1].length() - 2);
  // }
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
//        boolean isResearchFollowingAllowed = PreferenceManager.getInstance().getBoolean(AppConst.RESEARCH_FOLLOWING_NOTIFICATION, true);
//        if (isResearchFollowingAllowed)
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleApproveToJoinGroupNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleJoinGroupNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleRequestGroupMemberToJoinNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void handleUserLoginNotification(RemoteMessage remoteMessage) {
  String personId = remoteMessage.data[AppConst.PERSON_ID];
  String title = remoteMessage.data[AppConst.TITLE];
  String body = remoteMessage.data[AppConst.BODY];
  try {
    // body = URLDecoder.decode(body, "UTF-8");
  } catch (e) {
    e.printStackTrace();
  }
  if (personId != null && personId != userId) fireNotification(title, body, remoteMessage);
}

void fireNotification(String title, String body, RemoteMessage remoteMessage) {
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  print('Handling a background message ${remoteMessage.messageId}');
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.show(
    count,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channel.description,
        icon: 'ic_action_bar_titile',
        largeIcon: DrawableResourceAndroidBitmap("ic_action_bar_titile"),
        playSound: true,
      ),
    ),
  );
  count++;
}

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Stream<String> _tokenStream;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(PrefsKeys.LOGIN_RESPONSE)) {
    LoginResponse loginResponse = LoginResponse.fromJson(prefs.getString(PrefsKeys.LOGIN_RESPONSE));
    if (loginResponse != null) {
      userId = loginResponse.userId;
    } else {
      userId = "";
    }
  } else {
    userId = "";
  }
  if (Platform.isIOS)
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(RestartWidget(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences _prefs;
  Uri _latestUri;
  StreamSubscription _sub;
  String _sharedLang;
  bool _isVerified;
  ReceivePort _port = ReceivePort();
  LatestVersionBloc latestVersionBloc;
  @override
  initState() {
    super.initState();
    latestVersionBloc = serviceLocator<LatestVersionBloc>();
    latestVersionBloc.add(CheckVersion(context: context));
    bool firstTime = true;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      bool x = AppConst.CHECKED_VERSION_APP ?? false;
      if (!x) {
        bool connectionState = await GlobalPurposeFunctions.isInternet();
        if (connectionState) {
          firstTime = false;
          latestVersionBloc = serviceLocator<LatestVersionBloc>();
          latestVersionBloc.add(CheckVersion(context: context));
        } else {
          if (firstTime) {
            firstTime = false;
          }
        }
      } else {}
    });

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    FlutterDownloader.registerCallback(downloadCallback);
    _prefs = serviceLocator<SharedPreferences>();
    _sharedLang = _prefs.get(PrefsKeys.CULTURE_CODE);
    _isVerified = _prefs.getBool(PrefsKeys.IS_VERIFIED);
    initPlatformStateForUriUniLinks();
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage remoteMessage) {
      // open app from notification when app is closed
      if (remoteMessage != null) {
        int notificationType = int.parse(remoteMessage.data['notificationType']);
        switch (notificationType) {
          case AppConst.NEW_FOLLOW:
            {
              Navigator.of(context).pushNamed(
                SearchScreen.routeName,
              );
            }
            break;

          case AppConst.APPROVE_TO_JOIN_DPARTMENT:
            break;

          case AppConst.APPROVE_TO_JOIN_PATENT:
            break;

          case AppConst.ANSWER_EMPHASIS:
            break;

          case AppConst.ANSWER_ON_MY_QUESTION:
            break;

          case AppConst.CATEGORY_NEW_QUESTION:
            break;

          case AppConst.COMMENT_ON_MY_ANSWER:
            break;

          case AppConst.FOLLOWING_NEW_ANSWER:
            break;

          case AppConst.FOLLOWING_NEW_QUESTION:
            break;

          case AppConst.QUESTION_EMPHASIS:
            break;

          case AppConst.SUB_CATEGORY_NEW_QUESTION:
            break;

          case AppConst.COMMENT_ON_MY_BLOG:
            break;

          case AppConst.REPLY_ON_MY_COMMENT:
            break;

          case AppConst.BLOG_EMPHASIS:
            break;

          case AppConst.COMMENT_EMPHASIS:
            break;

          case AppConst.FOLLOWING_NEW_BLOG:
            break;

          case AppConst.FOLLOWING_NEW_COMMENT:
            break;

          case AppConst.CATEGORY_NEW_BLOG:
            break;

          case AppConst.SUB_CATEGORY_NEW_BLOG:
            break;

          case AppConst.FOLLOWING_NEW_RESEARCH:
            break;

          case AppConst.APPROVE_TO_JOIN_GROUP:
            break;

          // case AppConst.NEW_MESSAGE:
          //   handleNewMessageNotification(remoteMessage);
          //   break;

          case AppConst.JOIN_IN_GROUP:
            break;

          case AppConst.REQUEST_GROUP_MEMBER_TO_JOIN:
            break;

          case AppConst.USER_LOGIN:
            break;
        }
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      sendNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      // open app from notification when app is running or in the background
      int notificationType = int.parse(remoteMessage.data['notificationType']);
      switch (notificationType) {
        case AppConst.NEW_FOLLOW:
          {
            Navigator.of(context).pushNamed(
              SearchScreen.routeName,
            );
          }
          break;

        case AppConst.APPROVE_TO_JOIN_DPARTMENT:
          break;

        case AppConst.APPROVE_TO_JOIN_PATENT:
          break;

        case AppConst.ANSWER_EMPHASIS:
          break;

        case AppConst.ANSWER_ON_MY_QUESTION:
          break;

        case AppConst.CATEGORY_NEW_QUESTION:
          break;

        case AppConst.COMMENT_ON_MY_ANSWER:
          break;

        case AppConst.FOLLOWING_NEW_ANSWER:
          break;

        case AppConst.FOLLOWING_NEW_QUESTION:
          break;

        case AppConst.QUESTION_EMPHASIS:
          break;

        case AppConst.SUB_CATEGORY_NEW_QUESTION:
          break;

        case AppConst.COMMENT_ON_MY_BLOG:
          break;

        case AppConst.REPLY_ON_MY_COMMENT:
          break;

        case AppConst.BLOG_EMPHASIS:
          break;

        case AppConst.COMMENT_EMPHASIS:
          break;

        case AppConst.FOLLOWING_NEW_BLOG:
          break;

        case AppConst.FOLLOWING_NEW_COMMENT:
          break;

        case AppConst.CATEGORY_NEW_BLOG:
          break;

        case AppConst.SUB_CATEGORY_NEW_BLOG:
          break;

        case AppConst.FOLLOWING_NEW_RESEARCH:
          break;

        case AppConst.APPROVE_TO_JOIN_GROUP:
          break;

        // case AppConst.NEW_MESSAGE:
        //   handleNewMessageNotification(remoteMessage);
        //   break;

        case AppConst.JOIN_IN_GROUP:
          break;

        case AppConst.REQUEST_GROUP_MEMBER_TO_JOIN:
          break;

        case AppConst.USER_LOGIN:
          break;
      }
    });

    FirebaseMessaging.instance.getToken().then((token) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("FcmId", token);
      print("FcmId $token ");
    });
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen((token) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("FcmId", token);
      print("FcmId $token ");
    });
    //getInitialLink();
    //listinforback();
  }

  @override
  dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  /* Future<void> getInitialLink() async{
    const platform = MethodChannel("poc.deeplink.flutter.dev/channel");
    final link = await platform.invokeMethod("initialLink");
    setState(() {
        _latestUri = link;
    });
    print(link);
    try{

    }on PlatformException {
      
    }
  }

   listinforback(){
     const stream = const EventChannel('poc.deeplink.flutter.dev/events');
     stream.receiveBroadcastStream().listen((uri) {
       setState(() {
          _latestUri = uri;
       });
     }
     );
  } */

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
      });
    }, onError: (err) {
      if (!mounted) return;

      _latestUri = null;
    });
    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParameters}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      if (initialUri != null) if (!mounted) return;
      setState(() {
        _latestUri = initialUri;
      });
    } on PlatformException {
      initialUri = null;
    } on FormatException {
      initialUri = null;
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
    var _primaryColor = Color(0xff20273F);
    var _accentColor = Color(0xffEF5D2F);
    return RefreshConfiguration(
        headerBuilder: () =>
            WaterDropHeader(), // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
        footerBuilder: () => ClassicFooter(), // Configure default bottom indicator
        headerTriggerDistance: 50.0, // header trigger refresh trigger distance
        springDescription: SpringDescription(
            stiffness: 170,
            damping: 16,
            mass: 1.9), // custom spring back animate,the props meaning see the flutter api
        maxOverScrollExtent:
            50, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
        maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
        enableScrollWhenRefreshCompleted:
            false, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
        enableLoadingWhenFailed:
            true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
        hideFooterWhenNotFull:
            false, // Disable pull-up to load more functionality when Viewport is less than one screen
        enableBallisticLoad: true,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<MainBloc>(
              create: (context) => MainBloc(catalogService: serviceLocator<CatalogFacadeService>()),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Arachnoit',
            theme: ThemeData(
              unselectedWidgetColor: _accentColor,
              primarySwatch: AppConst.PRIMARYSWATCH,
              primaryColor: _primaryColor,
              accentColor: _accentColor,
              scaffoldBackgroundColor: Color(0xFFf7f7f7),
              appBarTheme: AppBarTheme(
                color: Colors.white,
                actionsIconTheme: IconThemeData(
                  color: _primaryColor,
                ),
                iconTheme: IconThemeData(
                  color: _primaryColor,
                ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Montserrat',
            ),
            onGenerateRoute: (settings) {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  print("the AppConst.CHECKED_VERSION_APP ${AppConst.CHECKED_VERSION_APP}");
                  var view;
                  if (AppConst.CHECKED_VERSION_APP == null) {
                    view = SplashScreen(
                      latestVersionBloc: latestVersionBloc,
                    );
                    return view;
                  } else if (_latestUri != null) {
                    final params = _latestUri.queryParameters;
                    switch (_latestUri.path) {
                      case '/Account/ValidateToken':
                        final email = params['email'];
                        final token = params['token'];
                        view = ForgetPasswordScreen(
                          email: email,
                          token: token,
                        );
                        _latestUri = null;
                        break;
                    }
                  } else if (settings.name == '/') if (_isVerified == null || _isVerified)
                    view = MainScreen();
                  else
                    view = VerificationScreen();
                  else if (settings.name == MainScreen.routeName)
                    view = MainScreen();
                  else if (settings.name == LoginScreen.routeName)
                    view = LoginScreen();
                  else if (settings.name == RegistrationScreen.routeName)
                    view = RegistrationScreen(
                        socailRegisterParam:
                            settings?.arguments ?? SocailRegisterParam(token: "-1"));
                  else if (settings.name == RegisterNormalUserScreen.routeName)
                    view = RegisterNormalUserScreen(socailRegisterParam: settings.arguments);
                  else if (settings.name == RegisterIndividualUserScreen.routeName)
                    view = RegisterIndividualUserScreen(socailRegisterParam: settings.arguments);
                  else if (settings.name == RegisterBusinessUserScreen.routeName)
                    view = RegisterBusinessUserScreen(socailRegisterParam: settings.arguments);
                  // else if (settings.name == RegistrationSocailScreen.routeName)
                  //   view = RegistrationSocailScreen();
                  // else if (settings.name ==
                  //     RegisterSocailNormalUserScreen.routeName)
                  //   view = RegisterSocailNormalUserScreen();
                  // else if (settings.name ==
                  //     RegisterSocailIndividualUserScreen.routeName)
                  //   view = RegisterSocailIndividualUserScreen();
                  // else if (settings.name ==
                  //     RegisterSocialBusinessUserScreen.routeName)
                  //   view = RegisterSocialBusinessUserScreen();
                  else if (settings.name == VerificationScreen.routeName)
                    view = VerificationScreen(); //LatestApkScreen
                  else if (settings.name == LatestApkScreen.routeName)
                    view = LatestApkScreen(isForceUpdate: settings.arguments);
                  else if (settings.name == ChangePasswordScreen.routeName)
                    view = ChangePasswordScreen();
                  else if (settings.name == AboutArachnoInTouchScreen.routeName)
                    view = AboutArachnoInTouchScreen();
                  else if (settings.name == UserManualScreen.routeName)
                    view = UserManualScreen();
                  else if (settings.name == SettingsPage.routeName)
                    view = SettingsPage();
                  else if (settings.name == QuestionDetailsScreen.routeName) {
                    LoginResponse userInfo = GlobalPurposeFunctions.getUserObject();
                    view = QuestionDetailsScreen(
                      questionId: settings.arguments,
                      userInfo: userInfo,
                    );
                  } else if (settings.name == BlogDetailsScreen.routeName) {
                    //   "blog_id":blog.id,
                    // "user_id":blog.healthcareProviderId
                    Map<String, String> arguments = settings.arguments as Map<String, String>;
                    view = BlogDetailsScreen(
                      blogId: arguments["blog_id"],
                      userId: arguments["user_id"],
                    );
                  } else if (settings.name == PhotoViewScreen.routeName)
                    view = PhotoViewScreen(photos: settings.arguments);
                  else if (settings.name == SinglePhotoViewScreen.routeName)
                    view = SinglePhotoViewScreen(photo: settings.arguments);
                  else if (settings.name == AllPublicGroupsScreen.routeName)
                    view = AllPublicGroupsScreen();
                  else if (settings.name == DiscoverCategriesDetailsScreen.routeName)
                    view = DiscoverCategriesDetailsScreen(category: settings.arguments);
                  else if (settings.name == DiscoverCategoriesSubCategoryAllBlogsScreen.routeName)
                    view = DiscoverCategoriesSubCategoryAllBlogsScreen(
                      subCategory: settings.arguments,
                    );
                  else if (settings.name == DiscoverCategoriesSubCategoryAllGroupsScreen.routeName)
                    view = DiscoverCategoriesSubCategoryAllGroupsScreen(
                      subCategory: settings.arguments,
                    );
                  else if (settings.name ==
                      DiscoverCategoriesSubCategoryAllQuestionsScreen.routeName)
                    view = DiscoverCategoriesSubCategoryAllQuestionsScreen(
                      subCategory: settings.arguments,
                    );
                  else if (settings.name == GroupDetailsScreen.routeName)
                    view = GroupDetailsScreen(groupId: settings.arguments);
                  else if (settings.name == GroupDetailsInfoScreen.routeName)
                    view = GroupDetailsInfoScreen(groupDetailsResponse: settings.arguments);
                  else if (settings.name == GroupDetailsSearchScreen.routeName)
                    view = GroupDetailsSearchScreen(
                      groupId: settings.arguments,
                    );
                  else if (settings.name == SearchScreen.routeName)
                    view = SearchScreen();
                  else if (settings.name == AddQuestionScreen.routeName) {
                    String questionId;
                    String groupId;
                    if (settings.arguments != null) {
                      Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
                      questionId = arguments['questionId'];
                      groupId = arguments['groupId'];
                    }
                    view = AddQuestion(
                      questionId: questionId,
                      groupId: groupId,
                    );
                  } else if (settings.name == AddBlogPage.routeName) {
                    String blogId;
                    GetBlogsResponse getBlogsResponse = GetBlogsResponse();
                    String groupId;
                    if (settings.arguments != null) {
                      Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;
                      blogId = arguments['blogId'];
                      getBlogsResponse = arguments['getBlogsResponse'];
                      groupId = arguments['groupId'];
                    }

                    view = AddBlogPage(
                      blogId: blogId,
                      getBlogsResponse: getBlogsResponse,
                      groupId: groupId,
                    );
                  } else if (settings.name == AddCategoryItem.routeName)
                    view = AddCategoryItem();
                  else if (settings.name == AddGroupPage.routeName)
                    view = AddGroupPage(
                      groupDetailsResponse: settings.arguments,
                    );

                  else if (settings.name == HomeGroupMembersScreen.routeName)
                    view = HomeGroupMembersScreen(
                      groupId: settings.arguments,
                    );
                  // else if (settings.name == AddNewItemCategory.routeName)
                  //   view = AddNewItemCategory(
                  //     categoryItem: settings.arguments,
                  //   );
                  // else if (settings.name == CollapsingTab.routeName)
                  //   view = CollapsingTab();
                  else if (settings.name == ProfileProviderScreen.routeName) {
                    LoginResponse userInfo =
                        LoginResponse.fromMap(json.decode(_prefs.get(PrefsKeys.LOGIN_RESPONSE)));
                    if (userInfo.userType == 0 || userInfo.userType == 1)
                      view = ProfileProviderScreen(
                        userId: userInfo.userId,
                      );
                    else {
                      view = ProfileNormalUser(
                        userId: userInfo.userId,
                      );
                    }
                  }

                  return view;
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  animation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (ctx) => HomeScreen(),
              );
            },
            supportedLocales: [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (_sharedLang == null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale != null && locale != null) if (supportedLocale.languageCode ==
                      locale.languageCode) {
                    return supportedLocale;
                  }
                }
              } else {
                return Locale(_sharedLang == "en-US" ? "en" : "ar", '');
              }
              return supportedLocales.first;
            },
          ),
        ));
  }
}
