import 'dart:convert';
import 'dart:io';
import 'package:arachnoit/application/group_details_blogs/group_details_blogs_bloc.dart';
import 'package:arachnoit/application/group_details_questions/group_details_questions_bloc.dart';
import 'package:arachnoit/application/group_details_search_blogs/group_details_search_blogs_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/screens/add_blog/add_blog_screen.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/sliver_delegate.dart';
import 'package:arachnoit/presentation/screens/group_add/group_add_screen.dart';
import 'package:arachnoit/presentation/screens/group_details_search/group_details_serach_screen.dart';
import 'package:arachnoit/presentation/screens/group_members_provider/home_gruop_memebers_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as ex;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/group_details/group_details_bloc.dart';
import '../../../common/check_permissions.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../common/pref_keys.dart';
import '../../../infrastructure/api/urls.dart';
import '../../../infrastructure/group_details/response/group_details_response.dart';
import '../../../infrastructure/login/response/login_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/group_details_member_image_privew_item.dart';
import '../group_details_blogs/group_details_blogs_screen.dart';
import '../group_details_info/group_details_info_screen.dart';
import '../group_details_questions/group_details_questions_screen.dart';

class GroupDetailsScreen extends StatefulWidget {
  static const routeName = '/group_details_screen';

  GroupDetailsScreen({Key key, @required this.groupId}) : super(key: key);

  final String groupId;

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

String groupIdDeleted;
GroupDetailsResponse groupIdUpdated;

class _GroupDetailsScreenState extends State<GroupDetailsScreen> with TickerProviderStateMixin {
  GroupDetailsBloc groupDetailsBloc;
  ScrollController scrollController;
  GroupDetailsBlogsBloc groupDetailsBlogsBloc;
  GroupDetailsQuestionsBloc groupDetailsQuestionsBloc;
  double sizePhoto = 40.0;
  double scale = 0.0;
  double constScale = 0.7142857142857143;
  ValueNotifier<double> newScale = ValueNotifier(1.5);
  GroupDetailsResponse groupDetailsResponse;
  SharedPreferences prefs;
  String userId;
  Map<String, dynamic> encodedHintMap;
  TabController primaryTC;
  String imageUpdated;
  bool takeBlogCountValueFromBloc = false;
  bool takeQuestionCountValueFromBloc = false;

  ValueNotifier<int> primaryTCChangeController = ValueNotifier<int>(0);

  _handleTabSelection() {
    primaryTCChangeController.value = primaryTC.animation.value.round();
  }

  @override
  void initState() {
    super.initState();
    groupIdDeleted = null;
    groupIdUpdated = null;
    scrollController = ScrollController();
    groupDetailsBlogsBloc = serviceLocator<GroupDetailsBlogsBloc>();
    groupDetailsQuestionsBloc = serviceLocator<GroupDetailsQuestionsBloc>();
    scrollController.addListener(updateValue);
    primaryTC = TabController(length: 2, vsync: this);
    primaryTC.addListener(tabControllerListener);
    groupDetailsBloc = serviceLocator<GroupDetailsBloc>();
    groupDetailsBloc.add(FetchGroupDetailsEvent(groupId: widget.groupId));
    prefs = serviceLocator<SharedPreferences>();
    userId = LoginResponse.fromJson(prefs.getString(PrefsKeys.LOGIN_RESPONSE)).userId;
    encodedHintMap = jsonDecode(prefs.getString(PrefsKeys.ENCODED_GROUP_HINT_MAP));
    primaryTC.animation.addListener(_handleTabSelection);
  }

  void updateValue() {
    if (scrollController.hasClients) {
      scale = scrollController.offset / 300;

      scale = scale * 2;

      if (scale >= 0.6) {
        newScale.value = 0.9;
      } else {
        newScale.value = 1.5 - (scale * constScale);
      }
    } else {
      newScale.value = 1.5;
    }
  }

  @override
  void dispose() {
    GlobalPurposeFunctions.changeStatusColor(Colors.white, false);
    primaryTC.removeListener(tabControllerListener);
    primaryTC.dispose();
    scrollController.dispose();
    super.dispose();
  }

  double sizeContainerTitle;
  int index;

  void tabControllerListener() {
    groupDetailsBloc.add(RefreshChangeTabsEvent());
    if (index != primaryTC.index) {
      index = primaryTC.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalPurposeFunctions.changeStatusColor(Color(0XFFDD4D31), true);
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupDetailsBloc>(
          create: (context) => groupDetailsBloc,
        ),
        BlocProvider<GroupDetailsBlogsBloc>(
          create: (context) => groupDetailsBlogsBloc,
        ),
        BlocProvider<GroupDetailsQuestionsBloc>(
          create: (context) => groupDetailsQuestionsBloc,
        ),
      ],
      child: BlocListener<GroupDetailsBloc, GroupDetailsState>(
        listener: (context, GroupDetailsState state) {
          GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          if (state is GroupDetailsFetchedState) {
            groupDetailsResponse = state.groupDetails;
          } else if (state is RemoteValidationErrorState)
            GlobalPurposeFunctions.showToast(
                AppLocalizations.of(context).check_your_internet_connection, context);
          else if (state is RemoteServerErrorState)
            GlobalPurposeFunctions.showToast(AppLocalizations.of(context).server_error, context);
          else if (state is RemoteClientErrorState)
            GlobalPurposeFunctions.showToast(
                AppLocalizations.of(context).check_your_internet_connection, context);
          else if (state is SuccessJoinedToGroup) {
            GlobalPurposeFunctions.showToast(state.message, context);
            groupDetailsResponse.requestStatus = state.joinedGroupResponse.requestStatus;
          } else if (state is FailedJoinedToGroup) {
            GlobalPurposeFunctions.showToast(state.message, context);
          } else if (state is DeleteGroupLoading) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          } else if (state is SuccessToAcceptedToGroup) {
            GlobalPurposeFunctions.showToast(AppLocalizations.of(context).process_success, context);
            groupDetailsResponse.requestStatus = 1;
          } else if (state is FailureToAcceptedToGroup) {
            GlobalPurposeFunctions.showToast(AppLocalizations.of(context).process_failure, context);
          } else if (state is SuccessDeleteGroup) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            groupIdDeleted = widget.groupId;
            Navigator.pop(context);
            GlobalPurposeFunctions.showToast(state.deleteGroupResponse.successMessage, context);
          }
        },
        child: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
          builder: (context, state) {
            return Scaffold(
              body: state is LoadingState
                  ? LoadingBloc()
                  : groupDetailsResponse != null
                      ? Scaffold(
                          floatingActionButton: (groupDetailsResponse.ownerId != null &&
                                  userId == groupDetailsResponse.ownerId)
                              ? FloatingActionButton(
                                  elevation: 2,
                                  child: Icon(Icons.edit),
                                  onPressed: () {
                                    if (primaryTC.index == 0) {
                                      Navigator.pushNamed(
                                        context,
                                        AddBlogPage.routeName,
                                        arguments: {
                                          'blogId': null,
                                          'groupId': groupDetailsResponse.groupId,
                                        },
                                      ).then((value) {
                                        if (value != null && (value as bool)) {
                                          groupDetailsBlogsBloc.add(GroupBlogPostsFetched(
                                              rebuildScreen: true,
                                              groupId: groupDetailsResponse.groupId));
                                        }
                                      });
                                    } else
                                      Navigator.pushNamed(
                                        context,
                                        AddQuestionScreen.routeName,
                                        arguments: {
                                          'questionId': null,
                                          'groupId': groupDetailsResponse.groupId,
                                        },
                                      ).then((value) {
                                        groupDetailsQuestionsBloc.add(GroupQuestionPostsFetched(
                                            groupId: groupDetailsResponse.groupId,
                                            refreshData: true));
                                      });
                                  })
                              : ValueListenableBuilder<int>(
                                  valueListenable: primaryTCChangeController,
                                  builder: (context, value, _) {
                                    if (value == 1) {
                                      return FloatingActionButton(
                                          elevation: 2,
                                          child: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, AddQuestionScreen.routeName,
                                                arguments: {
                                                  'questionId': null,
                                                  'groupId': groupDetailsResponse.groupId,
                                                });
                                          });
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                          body: SafeArea(
                            child: ex.NestedScrollView(
                                //physics: BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
                                controller: scrollController,
                                innerScrollPositionKeyBuilder: () {
                                  var index = '';
                                  if (primaryTC.index == 0) {
                                    index = 'Blogs';
                                  } else {
                                    index = 'Q&A';
                                  }
                                  return Key(index);
                                },
                                headerSliverBuilder:
                                    (BuildContext context, bool innerBoxIsScrolled) {
                                  return [
                                    flexibleSpaceWidget(),
                                    SliverToBoxAdapter(
                                      child: Column(
                                        children: [
                                          Card(
                                            elevation: 0.0,
                                            margin: EdgeInsets.only(bottom: 4),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      ClipOval(
                                                        child: Material(
                                                          color: Color(0xFF19444D),
                                                          // button color
                                                          child: InkWell(
                                                            splashColor: Colors.transparent,
                                                            // inkwell color
                                                            child: SizedBox(
                                                              width: 40,
                                                              height: 40,
                                                              child: Icon(
                                                                Icons.more_vert_outlined,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              _showBottomSheet(
                                                                  context: context,
                                                                  loginUserGroupPermissions:
                                                                      groupDetailsResponse
                                                                          .loginUserGroupPermissions);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      FlatButton(
                                                          onPressed: () {},
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(20)),
                                                          color: Color(0xFF19444D),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.message,
                                                                size: 17,
                                                                color: Colors.white,
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                AppLocalizations.of(context).chats,
                                                                style: mediumMontserrat(
                                                                    color: Colors.white,
                                                                    fontSize: 16),
                                                              ),
                                                            ],
                                                          )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      //   if (CheckPermissions.checkInviteMemberPermission(groupDetailsResponse.loginUserGroupPermissions))
                                                      //     Row(
                                                      //       children: [
                                                      //         FlatButton(
                                                      //             onPressed: () {},
                                                      //             shape: GlobalPurposeFunctions.buildButtonBorder(),
                                                      //             color: Theme.of(context).primaryColor,
                                                      //             child: Icon(
                                                      //               Icons.person_add_alt,
                                                      //               color: Colors.white,
                                                      //               size: 30,
                                                      //             )),
                                                      //         SizedBox(
                                                      //           width: 10,
                                                      //         )
                                                      //       ],
                                                      //     ),
                                                      if (groupDetailsResponse.requestStatus ==
                                                              null &&
                                                          userId != groupDetailsResponse.ownerId)
                                                        Row(
                                                          children: [
                                                            FlatButton(
                                                                onPressed: () {
                                                                  GlobalPurposeFunctions
                                                                      .showOrHideProgressDialog(
                                                                          context, true);
                                                                  groupDetailsBloc
                                                                      .add(JoinToGroupEvent(
                                                                    groupId:
                                                                        groupDetailsResponse.id,
                                                                  ));
                                                                },
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(40),
                                                                ),
                                                                color: Color(0xFFF65636),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.add,
                                                                      color: Colors.white,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      AppLocalizations.of(context)
                                                                          .join,
                                                                      style: mediumMontserrat(
                                                                          color: Colors.white,
                                                                          fontSize: 16),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                  if (groupDetailsResponse.privacyLevel == 3 &&
                                                      (encodedHintMap[groupDetailsResponse.id] ==
                                                              null ||
                                                          encodedHintMap[groupDetailsResponse.id] !=
                                                              false))
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                AppLocalizations.of(context)
                                                                    .message_encoded_group,
                                                                style: semiBoldMontserrat(
                                                                  color: Theme.of(context)
                                                                      .primaryColor,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                BlocProvider.of<GroupDetailsBloc>(
                                                                        context)
                                                                    .add(
                                                                        DisableEncodedHintMessageEvent(
                                                                  groupId: groupDetailsResponse.id,
                                                                  map: encodedHintMap,
                                                                ));
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                width: 35,
                                                                child: Center(
                                                                  child: Text(
                                                                    AppLocalizations.of(context).ok,
                                                                    style: mediumMontserrat(
                                                                      color: Theme.of(context)
                                                                          .accentColor,
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  if (groupDetailsResponse.requestStatus != -1)
                                                    if (groupDetailsResponse.requestStatus == 0 &&
                                                        userId != groupDetailsResponse.ownerId)
                                                      Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  AppLocalizations.of(context)
                                                                      .you_are_invited,
                                                                  style: mediumMontserrat(
                                                                    color: Theme.of(context)
                                                                        .primaryColor,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  GlobalPurposeFunctions
                                                                      .showOrHideProgressDialog(
                                                                          context, true);
                                                                  groupDetailsBloc.add(
                                                                      InjectedInviteGroup(
                                                                          groupId: widget.groupId));
                                                                },
                                                                child: Text(
                                                                  AppLocalizations.of(context)
                                                                      .inject,
                                                                  style: mediumMontserrat(
                                                                    color: Colors.white,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                color: Colors.orange[600],
                                                                visualDensity: VisualDensity(
                                                                    horizontal: -4, vertical: -1),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  GlobalPurposeFunctions
                                                                      .showOrHideProgressDialog(
                                                                          context, true);
                                                                  groupDetailsBloc.add(
                                                                      AcceptedInviteGroup(
                                                                          groupId: widget.groupId));
                                                                },
                                                                child: Text(
                                                                  AppLocalizations.of(context)
                                                                      .accept,
                                                                  style: mediumMontserrat(
                                                                    color: Colors.white,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                color:
                                                                    Theme.of(context).accentColor,
                                                                visualDensity: VisualDensity(
                                                                    horizontal: -4, vertical: -1),
                                                              )
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Theme.of(context).primaryColor,
                                                          )
                                                        ],
                                                      ),
                                                  Divider(
                                                    thickness: 2,
                                                    color: Color(0XFFE5E5E5),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  AppLocalizations.of(context)
                                                                      .blogs,
                                                                  style: mediumMontserrat(
                                                                      fontSize: 15,
                                                                      color: Colors.black
                                                                          .withOpacity(0.5))),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              BlocListener<GroupDetailsBlogsBloc,
                                                                  GroupDetailsBlogsState>(
                                                                listener: (context, state) {
                                                                  if (state.status ==
                                                                      BLogPostStatus.success) {
                                                                    takeBlogCountValueFromBloc =
                                                                        true;
                                                                  }
                                                                },
                                                                child: BlocBuilder<
                                                                        GroupDetailsBlogsBloc,
                                                                        GroupDetailsBlogsState>(
                                                                    builder: (context, state) {
                                                                  return Text(
                                                                      takeBlogCountValueFromBloc
                                                                          ? '${state.posts.length.toString()}'
                                                                          : groupDetailsResponse
                                                                              .blogsCount
                                                                              .toString(),
                                                                      style: boldMontserrat(
                                                                        fontSize: 15,
                                                                        color: Colors.black,
                                                                      ));
                                                                }),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        VerticalDivider(
                                                          width: 5,
                                                          color: Color(0XFFE5E5E5),
                                                          thickness: 2,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  AppLocalizations.of(context)
                                                                      .questionAndAnswer,
                                                                  style: mediumMontserrat(
                                                                      fontSize: 15,
                                                                      color: Colors.black
                                                                          .withOpacity(0.5))),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              BlocListener<
                                                                  GroupDetailsQuestionsBloc,
                                                                  GroupDetailsQuestionsState>(
                                                                listener: (context, state) {
                                                                  if (state.status ==
                                                                      QaaPostStatus.success) {
                                                                    takeQuestionCountValueFromBloc =
                                                                        true;
                                                                  }
                                                                },
                                                                child: BlocBuilder<
                                                                        GroupDetailsQuestionsBloc,
                                                                        GroupDetailsQuestionsState>(
                                                                    builder: (context, state) {
                                                                  return Text(
                                                                      takeQuestionCountValueFromBloc
                                                                          ? '${state.posts.length}'
                                                                          : groupDetailsResponse
                                                                              .questionsCount
                                                                              .toString(),
                                                                      style: boldMontserrat(
                                                                        fontSize: 15,
                                                                        color: Colors.black,
                                                                      ));
                                                                }),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        VerticalDivider(
                                                          width: 5,
                                                          color: Color(0XFFE5E5E5),
                                                          thickness: 2,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  AppLocalizations.of(context)
                                                                      .members,
                                                                  style: mediumMontserrat(
                                                                      fontSize: 15,
                                                                      color: Colors.black
                                                                          .withOpacity(0.5))),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                  '${groupDetailsResponse.membersCount}',
                                                                  style: boldMontserrat(
                                                                    fontSize: 15,
                                                                    color: Colors.black,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        if (CheckPermissions
                                                            .checkInviteMemberPermission(
                                                                groupDetailsResponse
                                                                    .loginUserGroupPermissions))
                                                          Row(
                                                            children: [
                                                              VerticalDivider(
                                                                width: 5,
                                                                color: Color(0XFFE5E5E5),
                                                                thickness: 2,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal: 10),
                                                                child: GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(context).pushNamed(
                                                                          GroupDetailsInfoScreen
                                                                              .routeName,
                                                                          arguments:
                                                                              groupDetailsResponse);
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Stack(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                GroupDetailsMemberImagePreviewItem(
                                                                                  imageUrl: groupDetailsResponse
                                                                                              .groupMembers
                                                                                              .length >
                                                                                          0
                                                                                      ? groupDetailsResponse
                                                                                          .groupMembers[
                                                                                              0]
                                                                                          .photo
                                                                                      : '',
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 30,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            PositionedDirectional(
                                                                                start: 12,
                                                                                child:
                                                                                    GroupDetailsMemberImagePreviewItem(
                                                                                  imageUrl: groupDetailsResponse
                                                                                              .groupMembers
                                                                                              .length >
                                                                                          1
                                                                                      ? groupDetailsResponse
                                                                                          .groupMembers[
                                                                                              1]
                                                                                          .photo
                                                                                      : '',
                                                                                )),
                                                                            PositionedDirectional(
                                                                                start: 24,
                                                                                child:
                                                                                    GroupDetailsMemberImagePreviewItem(
                                                                                  imageUrl: groupDetailsResponse
                                                                                              .groupMembers
                                                                                              .length >
                                                                                          2
                                                                                      ? groupDetailsResponse
                                                                                          .groupMembers[
                                                                                              2]
                                                                                          .photo
                                                                                      : '',
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        IconButton(
                                                                          icon: Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Color(0XFF222740),
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.of(context).pushNamed(
                                                                                HomeGroupMembersScreen
                                                                                    .routeName,
                                                                                arguments:
                                                                                    groupDetailsResponse
                                                                                        .groupId);
                                                                          },
                                                                        )
                                                                      ],
                                                                    )),
                                                              )
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SliverPersistentHeader(
                                        pinned: true,
                                        delegate: SliverAppBarDelegate(
                                          TabBar(
                                            controller: primaryTC,
                                            isScrollable: false,
                                            unselectedLabelColor: Color(0XFF19444C),
                                            labelColor: Theme.of(context).accentColor,
                                            indicatorColor: Theme.of(context).accentColor,
                                            labelStyle: boldCircular(
                                              color: Theme.of(context).accentColor,
                                              fontSize: 14,
                                            ),
                                            tabs: <Tab>[
                                              Tab(
                                                text: AppLocalizations.of(context).blogs,
                                              ),
                                              Tab(
                                                text:
                                                    AppLocalizations.of(context).questionAndAnswer,
                                              ),
                                            ],
                                          ),
                                        ))
                                  ];
                                },
                                body: Column(
                                  children: [
                                    Expanded(
                                      child: TabBarView(controller: primaryTC, children: [
                                        ex.NestedScrollViewInnerScrollPositionKeyWidget(
                                          const Key('Blogs'),
                                          GroupDetailsBlogsScreen(
                                            groupId: groupDetailsResponse.groupId,
                                            groupDetailsBlogsBloc: groupDetailsBlogsBloc,
                                          ),
                                        ),
                                        ex.NestedScrollViewInnerScrollPositionKeyWidget(
                                            const Key('Q&A'),
                                            GroupDetailsQuestionsScreen(
                                              groupId: groupDetailsResponse.groupId,
                                              groupDetailsQuestionsBloc: groupDetailsQuestionsBloc,
                                            )),
                                      ]),
                                    ),
                                  ],
                                )),
                          ),
                        )
                      : BlocError(
                          context: context,
                          blocErrorState: BlocErrorState.userError,
                          function: () {
                            groupDetailsBloc.add(FetchGroupDetailsEvent(groupId: widget.groupId));
                          }),
            );
          },
        ),
      ),
    );
  }

  Widget flexibleSpaceWidget() {
    return SliverAppBar(
      expandedHeight: 150.0,
      pinned: true,
      floating: false,
      snap: false,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Theme.of(context).accentColor,
      actions: [
        Row(
          children: [
            if (groupDetailsResponse != null)
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(GroupDetailsSearchScreen.routeName,
                        arguments: groupDetailsResponse.id);
                  }),
            SizedBox(
              width: 10,
            ),
          ],
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          titlePadding: EdgeInsets.only(top: 1, bottom: 10, left: 50, right: 50),
          stretchModes: [StretchMode.blurBackground],
          title: ValueListenableBuilder<double>(
            valueListenable: newScale,
            builder: (context, value, _) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildActionsNew(context),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                groupDetailsResponse.name ?? '',
                                style: regularMontserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  groupDetailsResponse.privacyLevel == 0
                                      ? 'assets/images/ic_public.svg'
                                      : groupDetailsResponse.privacyLevel == 1
                                          ? 'assets/images/ic_lock.svg'
                                          : groupDetailsResponse.privacyLevel == 2
                                              ? 'assets/images/ic_private.svg'
                                              : groupDetailsResponse.privacyLevel == 3
                                                  ? 'assets/images/ic_encoded.svg'
                                                  : groupDetailsResponse.privacyLevel == 4
                                                      ? 'assets/images/ic_public.svg'
                                                      : '',
                                  color: Colors.white,
                                  fit: BoxFit.cover,
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                    groupDetailsResponse.privacyLevel == 0
                                        ? AppLocalizations.of(context).public
                                        : groupDetailsResponse.privacyLevel == 1
                                            ? AppLocalizations.of(context).closed
                                            : groupDetailsResponse.privacyLevel == 2
                                                ? AppLocalizations.of(context).private
                                                : groupDetailsResponse.privacyLevel == 3
                                                    ? AppLocalizations.of(context).encoded
                                                    : groupDetailsResponse.privacyLevel == 4
                                                        ? 'Training'
                                                        : '',
                                    textAlign: TextAlign.start,
                                    style: lightMontserrat(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ]);
            },
          ),
          background: Container(
            padding: EdgeInsets.only(top: 70, left: 15),
            color: Color(0xFFF65636),
          )),
      //   ],
    );
  }

  Widget _buildActionsNew(BuildContext context) {
    print('imgae url${groupDetailsResponse.image.localeImage}');
    Widget profile = new GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 10, top: 10, left: 10),
        width: sizePhoto,
        height: sizePhoto,
        child: (groupDetailsResponse.image != null &&
                groupDetailsResponse.image.url != null &&
                groupDetailsResponse.image.url != "")
            ? ChachedNetwrokImageView(
                isCircle: true,
                imageUrl: groupDetailsResponse.image.url,
              )
            : (groupDetailsResponse.image.localeImage != null &&
                    groupDetailsResponse.image.localeImage != '')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      File(groupDetailsResponse.image.localeImage),
                      fit: BoxFit.cover,
                    ),
                  )
                : SvgPicture.asset(
                    "assets/images/ic_user_icon.svg",
                    color: Theme.of(context).primaryColor,
                    fit: BoxFit.cover,
                  ),
      ),
    );

    return new Transform(
      transform: new Matrix4.identity()..scale(newScale.value, newScale.value),
      alignment: Alignment.bottomCenter,
      child: profile,
    );
  }

  Future _showBottomSheet({
    @required BuildContext context,
    @required List<int> loginUserGroupPermissions,
  }) {
    return showModalBottomSheet<dynamic>(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                color: Colors.white),
            child: Wrap(children: [
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.miscellaneous_services,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context).more_option,
                                style: mediumMontserrat(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding:
                            (CheckPermissions.checkEditGroupPermission(loginUserGroupPermissions))
                                ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                                : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: (CheckPermissions.checkEditBlogPermission(loginUserGroupPermissions))
                            ? InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, AddGroupPage.routeName,
                                          arguments: groupDetailsResponse)
                                      .then((value) {
                                    // value is image after update
                                    print(value);
                                    if (value != null) {
                                      Map val = value;
                                      groupIdUpdated = groupDetailsResponse;
                                      imageUpdated = val['picture'];
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context).edit_group,
                                      style: lightMontserrat(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.group_work_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context).sub_group,
                                style: lightMontserrat(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding:
                            (CheckPermissions.checkRemoveGroupPermission(loginUserGroupPermissions))
                                ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                                : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child:
                            (CheckPermissions.checkRemoveGroupPermission(loginUserGroupPermissions))
                                ? InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      groupDetailsBloc
                                          .add(DeleteGroupEvent(groupId: groupDetailsResponse.id));
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          AppLocalizations.of(context).delete_group,
                                          style: lightMontserrat(
                                            fontSize: 14,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(GroupDetailsInfoScreen.routeName,
                                arguments: groupDetailsResponse);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context).group_information,
                                  style: lightMontserrat(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        });
  }
}

/* class ScrollParent extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  ScrollParent({this.controller, this.child});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (OverscrollNotification value) {
        if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
          if (controller.offset != 0) controller.jumpTo(0);
          return true;
        }
        if (controller.offset + value.overscroll >=
            controller.position.maxScrollExtent) {
          if (controller.offset != controller.position.maxScrollExtent)
            controller.jumpTo(controller.position.maxScrollExtent);
          return true;
        }
        controller.jumpTo(controller.offset + value.overscroll);
        return true;
      },
      child: child,
    );
  }
} */
