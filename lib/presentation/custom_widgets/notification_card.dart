// //import 'package:arachnoit/infrastructure/notification/response/notification_response.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:arachnoit/application/notification_provider/notification_bloc.dart';
// import 'package:arachnoit/common/global_prupose_functions.dart';
// import 'package:arachnoit/infrastructure/notification/response/get_notification_response.dart';
// import 'package:arachnoit/injections.dart';
// import 'package:arachnoit/presentation/screens/active_session/active_session.dart';
// import 'package:arachnoit/presentation/screens/blog_details/blog_details_screen.dart';
// import 'package:arachnoit/presentation/screens/blogs_vote/blogs_vote_screen.dart';
// import 'package:arachnoit/presentation/screens/group_details/group_details_screen.dart';
// import 'package:arachnoit/presentation/screens/groups/groups_screen.dart';
// import 'package:arachnoit/presentation/screens/home_qaa/home_qaa_screen.dart';
// import 'package:arachnoit/presentation/screens/question_details/question_details_screen.dart';
// import 'package:device_info/device_info.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wifi_info_flutter/wifi_info_flutter.dart';

// class NotificationCard extends StatefulWidget {
//   const NotificationCard({
//     this.body,
//     this.title,
//     this.personNotification,
//   }) : super();

//   final String title;
//   final String body;
//   final PersonNotification personNotification;

//   @override
//   _NotificationCardState createState() => _NotificationCardState();
// }

// class _NotificationCardState extends State<NotificationCard> {
//   NotificationBloc notificationBloc;
//   String wifiIP = "";
//   AndroidDeviceInfo mobileInfo;
//   Map<String, dynamic> deviceData = <String, dynamic>{};
//   static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

//   Future<String> getIpAddress() async {
//     try {
//       wifiIP = await WifiInfo().getWifiIP();
//       return wifiIP;
//     } catch (e) {
//       print("the error happened is $e");
//     }
//   }

//   Future<AndroidDeviceInfo> initPlatformState() async {
//     try {
//       if (Platform.isAndroid) {
//         mobileInfo = await deviceInfoPlugin.androidInfo;
//         return mobileInfo;
//       } else if (Platform.isIOS) {
//         // deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
//       }
//     } on PlatformException {
//       deviceData = <String, dynamic>{
//         'Error:': 'Failed to get platform version.'
//       };
//     }
//   }

//   Widget navigateForActiveFuncation({
//     Function activeFunction,
//   }) {
//     print("Doness");
//     return InkWell(
//       onTap: activeFunction,
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     notificationBloc = serviceLocator<NotificationBloc>();
//   }

//   //Color myColor = Colors.grey[100].withOpacity(0.6);
//   @override
//   Widget build(BuildContext context) {
//     Color mainColor = Colors.grey[100].withOpacity(0.6);
//     Map<String, dynamic> notificationData =
//         jsonDecode(widget.personNotification.requestData);

//     return BlocProvider<NotificationBloc>(
//       create: (context) => notificationBloc,
//       child: BlocBuilder<NotificationBloc, NotificationState>(
//         builder: (context, state) {
//           if (state.status ==
//                   NotificationProviderStatus.successReadNotification ||
//               widget.personNotification.isRead) {
//             print("is it Read ??${widget.personNotification.isRead}");
//             mainColor = Colors.grey[200].withOpacity(0.6);
//             print("Success read");
//           }
//           return Container(
//             child: Card(
//               elevation: 5.0,
//               color: mainColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(0.0),
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 10.0,
//                   vertical: 10.0,
//                 ),
//                 child: ListTile(
//                   leading: Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     child: Icon(
//                       Icons.add_alert,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text(
//                     widget.title,
//                     style: TextStyle(
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   subtitle: Text(
//                     widget.body,
//                     maxLines: 2,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onTap: () {
//                     notificationBloc..add(
//                         ReadUserNotificationEvent(
//                           notificationId: <String>[
//                             widget.personNotification.notificationId
//                           ],
//                         ),
//                       );
//                     switch (widget.personNotification.notificationType) {
//                       case NotificationType.ANSWER_ON_MY_QUESTION:
//                         navigationFunction(
//                           context,
//                           QuestionDetailsScreen(
//                             questionId: notificationData['AnswerId'],
//                             userInfo: GlobalPurposeFunctions.getUserObject(),
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.APPROVE_TO_JOIN_GROUP:
//                         navigationFunction(
//                           context,
//                           GroupDetailsScreen(
//                             groupId: notificationData['ItemId'],
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.APPROVE_TO_JOIN_PATENT:
//                         navigationFunction(
//                             context, GroupsScreen(), notificationBloc);
//                         break;
//                       case NotificationType.BLOG_EMPHASIS:
//                         navigationFunction(
//                           context,
//                           BlogDetailsScreen(
//                             blogId: notificationData['BlogId'],
//                             userInfo: GlobalPurposeFunctions.getUserObject(),
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.COMMENT_ON_MY_ANSWER:
//                         navigationFunction(
//                             context, HomeQaaScreen(), notificationBloc);
//                         break;
//                       case NotificationType.FOLLOWING_NEW_ANSWER:
//                         navigationFunction(
//                           context,
//                           QuestionDetailsScreen(
//                             questionId: notificationData['QuestionId'],
//                             userInfo: GlobalPurposeFunctions.getUserObject(),
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.FOLLOWING_NEW_BLOG:
//                         navigationFunction(
//                           context,
//                           BlogDetailsScreen(
//                             blogId: notificationData['BlogId'],
//                             userInfo: GlobalPurposeFunctions.getUserObject(),
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.FOLLOWING_NEW_COMMENT:
//                         navigationFunction(
//                             context, GroupsScreen(), notificationBloc);
//                         break;
//                       case NotificationType.FOLLOWING_NEW_QUESTION:
//                         navigationFunction(
//                           context,
//                           QuestionDetailsScreen(
//                             questionId: notificationData['QuestionId'],
//                             userInfo: GlobalPurposeFunctions.getUserObject(),
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.JOIN_IN_GROUP:
//                         navigationFunction(
//                           context,
//                           GroupDetailsScreen(
//                             groupId: notificationData['ItemId'],
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.QUESTION_EMPHASIS:
//                         navigationFunction(
//                           context,
//                           QuestionDetailsScreen(
//                             questionId: notificationData['QuestionId'],
//                             userInfo: GlobalPurposeFunctions.getUserObject(),
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.REPLY_ON_MY_COMMENT:
//                         navigationFunction(
//                           context,
//                           BlogsVoteScreen(
//                             itemID: notificationData['BlogId'],
//                           ),
//                           notificationBloc,
//                         );
//                         break;
//                       case NotificationType.USER_LOGIN:
//                         navigateForActiveFuncation(
//                           activeFunction: () async {
//                             mobileInfo = await initPlatformState();
//                             wifiIP = await getIpAddress();
//                             //Navigator.of(context).pop();
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => ActiveSession(
//                                   mobileInfo: mobileInfo,
//                                   wifiIP: wifiIP,
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                         //       navigationFunction(
//                         //           context, ActiveSession(
//                         //              mobileInfo : await initPlatformState();
//                         // wifiIP :  getIpAddress();
//                         //           ), notificationBloc,);
//                         break;
//                       default:
//                     }
//                   },
//                 ),
//               ),
//             ),
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//           );
//         },
//       ),
//     );
//   }
// }

// void navigationFunction(
//   BuildContext context,
//   Widget navigationScreen,
//   NotificationBloc notificationBloc,
// ) {
//   Navigator.of(context)
//     ..push(
//       MaterialPageRoute(
//         builder: (context) {
//           return navigationScreen;
//         },
//       ),
//     );
// }
