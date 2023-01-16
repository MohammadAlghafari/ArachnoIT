import 'dart:async';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/comment_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/doctor_dialog_info.dart';
import 'package:arachnoit/presentation/custom_widgets/pop_up_menu.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/report_dialog.dart';
import 'package:arachnoit/presentation/custom_widgets/video_player.dart';
import 'package:arachnoit/presentation/screens/blogs_details_replay/blogs_detail_replay_screen.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/blog_details/blog_details_bloc.dart';
import '../../../common/check_permissions.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../common/pref_keys.dart';
import '../../../infrastructure/api/urls.dart';
import '../../../infrastructure/blog_details/response/blog_details_response.dart';
import '../../../infrastructure/login/response/login_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/blog_comment_item.dart';
import '../../custom_widgets/document_file_item.dart';
import '../../custom_widgets/needs_login_dialog.dart';
import '../photo_view/photo_view_screen.dart';

class BlogDetailsScreen extends StatefulWidget {
  static const routeName = '/blog_details_screen';
  final String userId;

  BlogDetailsScreen({Key key, @required this.blogId, @required this.userId})
      : super(key: key);
  final String blogId;

  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen>
    with TickerProviderStateMixin {
  PopupMenu menu;
  BlogDetailsBloc blogDetailsBloc;
  BlogDetailsResponse blogDetailsResponse;
  TextEditingController _commentController;
  List<CommentResponse> comments = [];
  bool isUpdateClickIcon = false;
  int selectedIndex = 0, lastSelectedUpdateIndex = 0;
  final key = GlobalKey();
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    blogDetailsBloc = serviceLocator<BlogDetailsBloc>()
      ..add(FetchBlogDetailsEvent(
        blogId: widget.blogId,
      ));
    _commentController = TextEditingController();
    controller = new ScrollController();

    menu = PopupMenu(
      items: [
        MenuItem(
            title: "delete",
            textStyle: mediumMontserrat(
              color: Colors.black,
              fontSize: 16,
            )),
        MenuItem(
            title: "update",
            textStyle: mediumMontserrat(color: Colors.black, fontSize: 16)),
        MenuItem(
            title: "report",
            textStyle: mediumMontserrat(color: Colors.black, fontSize: 16)),
      ],
      maxColumn: 1,
      backgroundColor: Colors.white.withOpacity(0.8),
    );
  }

  void stateChanged(bool isShow) {}

  void onClickMenu(MenuItemProvider item) {
    if (GlobalPurposeFunctions.getUserObject() == null) {
    } else {
      if (item.menuTitle == AppLocalizations.of(context).delete) {
        GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
        blogDetailsBloc.add(DelteComment(
            selectCommentIndex: selectedIndex,
            commentId: comments[selectedIndex].id));
      } else if (item.menuTitle == AppLocalizations.of(context).update) {
        blogDetailsBloc.add(IsUpdateClickEvent(state: true));
      } else if (item.menuTitle == AppLocalizations.of(context).report) {
        TextEditingController _controller = TextEditingController();
        showDialog(
          context: context,
          builder: (context) => ReportDialog(
            userInfo: GlobalPurposeFunctions.getUserObject(),
            reportFunction: () {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              blogDetailsBloc.add(SendReport(
                commentId: comments[selectedIndex].id,
                description: _controller.text,
              ));
            },
            reportController: _controller,
          ),
        );
      }
    }
  }

  void onDismiss() {}
  RefreshController refreshController = RefreshController();

  @override
  void dispose() {
    super.dispose();
    menu.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Navigator.pop(context);
        Navigator.of(context).pop({
          "like": blogDetailsResponse?.usefulCount ?? -1,
          "emphases": blogDetailsResponse?.emphasisCount ?? -1,
        });
      },
      child: Scaffold(
        appBar: AppBarProject.showAppBar(
          title: AppLocalizations.of(context).comments,
        ),
        body: BlocProvider(
          create: (context) => blogDetailsBloc,
          child: BlocListener<BlogDetailsBloc, BlogDetailsState>(
            listener: (context, state) {
              if (state is BlogDetailsFetchedState) {
                refreshController.refreshCompleted();
              } else {
                refreshController.refreshFailed();
              }
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {});
              if (state is GetBriedProfileSuceess)
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) {
                  showDialog(
                    context: context,
                    builder: (context) => DoctorDialogInfo(
                      info: state.profileInfo,
                    ),
                  );
                });
              if (state is SendReportSuccess) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) {
                  GlobalPurposeFunctions.showToast(state.message, context);
                  Navigator.pop(context);
                });
              } else if (state is FailedSendReport) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                GlobalPurposeFunctions.showToast(state.message, context);
              } else if (state is SuccessDeleteComment) {
                if (selectedIndex == lastSelectedUpdateIndex) {
                  lastSelectedUpdateIndex = 0;
                  _commentController.text = "";
                  isUpdateClickIcon = false;
                }
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) {});
                comments.removeAt(state.selectCommentIndex);
                Timer(Duration(milliseconds: 500), () {
                  controller.animateTo(controller.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                });
              } else if (state is IsUpdateClickState) {
                if (state.state) {
                  lastSelectedUpdateIndex = selectedIndex;
                  _commentController.text = comments[selectedIndex].body;
                } else {
                  lastSelectedUpdateIndex = 0;
                  _commentController.text = "";
                }
                isUpdateClickIcon = state.state;
              } else if (state is SuccessUpdateCommentSuccess) {
                comments[state.selectCommentIndex].body = state.newBody;
                lastSelectedUpdateIndex = 0;
                _commentController.text = "";
                isUpdateClickIcon = false;
                Timer(Duration(milliseconds: 500), () {
                  controller.animateTo(controller.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                });
              } else if (state is SucessAddNewComment) {
                _commentController.text = "";

                comments.add(state.blogCommentReponse);
                Timer(Duration(milliseconds: 500), () {
                  controller.animateTo(controller.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                });
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                    .then((value) {});
              } else if (state is BlogDetailsFetchedState) {
                blogDetailsResponse = state.blogDetails;
                comments = blogDetailsResponse.comments;
              } else if (state is VoteEmphasisState) {
                if (blogDetailsResponse.markedAsEmphasis) {
                  blogDetailsResponse.emphasisCount -= 1;
                  blogDetailsResponse.markedAsEmphasis =
                  !blogDetailsResponse.markedAsEmphasis;
                } else {
                  blogDetailsResponse.emphasisCount += 1;
                  blogDetailsResponse.markedAsEmphasis =
                  !blogDetailsResponse.markedAsEmphasis;
                  if (!blogDetailsResponse.markedAsUseful) {
                    blogDetailsResponse.usefulCount += 1;
                    blogDetailsResponse.markedAsUseful =
                    !blogDetailsResponse.markedAsUseful;
                  }
                }
              } else if (state is VoteUsefulState) {
                if (blogDetailsResponse.markedAsUseful) {
                  blogDetailsResponse.usefulCount -= 1;
                  blogDetailsResponse.markedAsUseful =
                  !blogDetailsResponse.markedAsUseful;
                  if (blogDetailsResponse.markedAsEmphasis) {
                    blogDetailsResponse.emphasisCount -= 1;
                    blogDetailsResponse.markedAsEmphasis =
                    !blogDetailsResponse.markedAsEmphasis;
                  }
                } else {
                  GlobalPurposeFunctions.showOrHideProgressDialog(
                      context, false);
                  blogDetailsResponse.usefulCount += 1;
                  blogDetailsResponse.markedAsUseful =
                  !blogDetailsResponse.markedAsUseful;
                }
              }
            },
            child: BlocBuilder<BlogDetailsBloc, BlogDetailsState>(
              builder: (context, state) {
                return Container(
                    child: state is LoadingState
                        ? LoadingBloc()
                        : blogDetailsResponse != null
                            ? Stack(
                                children: [
                                  Column(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: RefreshData(
                                          refreshController: refreshController,
                                          onRefresh: () {
                                            blogDetailsBloc
                                                .add(FetchBlogDetailsEvent(
                                              blogId: widget.blogId,
                                              isRefreshData: true,
                                            ));
                                          },
                                          body: ListView(
                                              controller: controller,
                                              children: [
                                                Column(
                                                  children: [
                                                    Card(
                                                      elevation: 0.0,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              showImage(),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    showUserNameAndBottomIcon(),
                                                                    Text(
                                                                      blogDetailsResponse
                                                                          .specification,
                                                                      textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                      style:
                                                                      lightMontserrat(
                                                                        fontSize:
                                                                        14,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      blogDetailsResponse
                                                                          .subSpecification,
                                                                      textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                      style:
                                                                      lightMontserrat(
                                                                        fontSize:
                                                                        14,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          _handleAttachment(
                                                              blogDetailsResponse
                                                                  .blogType,
                                                              true),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right:
                                                                  10),
                                                              child:
                                                              AutoDirection(
                                                                text:
                                                                blogDetailsResponse
                                                                    .title,
                                                                child: Text(
                                                                  blogDetailsResponse
                                                                      .title,
                                                                  style:
                                                                  mediumMontserrat(
                                                                    fontSize:
                                                                    18,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right:
                                                                  10),
                                                              child: Text(
                                                                DateFormat.yMd(
                                                                    'en')
                                                                    .format(
                                                                    DateTime
                                                                        .parse(
                                                                        blogDetailsResponse
                                                                            .creationDate)),
                                                                style:
                                                                lightMontserrat(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right:
                                                                  10),
                                                              child: Text(
                                                                blogDetailsResponse
                                                                    .category,
                                                                style:
                                                                regularMontserrat(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right:
                                                                  10),
                                                              child: Text(
                                                                blogDetailsResponse
                                                                    .subCategory,
                                                                style:
                                                                regularMontserrat(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )),
                                                          Row(
                                                            children: [
                                                              showBodyText()
                                                            ],
                                                          ),
                                                          SizedBox(height: 20),
                                                          Divider(
                                                            thickness: 0.2,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(height: 5),
                                                          showButtomReaction(),
                                                          SizedBox(height: 10)
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topLeft,
                                                      child: Container(
                                                          margin:
                                                          EdgeInsets.only(
                                                              left: 15,
                                                              right: 15),
                                                          child: AutoDirection(
                                                            text: "hello",
                                                            child: Text(
                                                              "${AppLocalizations
                                                                  .of(context)
                                                                  .comments}(" +
                                                                  comments
                                                                      .length
                                                                      .toString() +
                                                                  ")",
                                                              style:
                                                              semiBoldMontserrat(
                                                                fontSize: 17,
                                                                color: Theme
                                                                    .of(
                                                                    context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Divider(
                                                      color: Theme
                                                          .of(context)
                                                          .primaryColor,
                                                      endIndent: 15,
                                                      indent: 15,
                                                      thickness: 0.6,
                                                    ),
                                                    if (comments.length > 0)
                                                      showComments()
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  addCommectTextField()
                                ],
                              )
                            : (state is RemoteServerErrorState)
                                ? BlocError(
                                    blocErrorState: BlocErrorState.serverError,
                                    function: () {
                                      blogDetailsBloc
                                        ..add(FetchBlogDetailsEvent(
                                          blogId: widget.blogId,
                                        ));
                                    },
                                    context: context)
                                : (state is RemoteClientErrorState)
                                    ? BlocError(
                        blocErrorState:
                        BlocErrorState.userError,
                                        function: () {
                                          blogDetailsBloc
                                            ..add(FetchBlogDetailsEvent(
                                              blogId: widget.blogId,
                                            ));
                                        },
                                        context: context)
                                    : Container());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget showUserNameAndBottomIcon() {
    return BlocBuilder<BlogDetailsBloc, BlogDetailsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: InkWell(
                child: Text(
                  blogDetailsResponse.inTouchPointName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                  style: semiBoldMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  blogDetailsBloc.add(GetProfileBridEvent(
                      context: context, userId: widget.userId));
                },
              ),
            ),
            IconButton(
                icon: Icon(Icons.more_horiz),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                  var isVisitor, isMyBlog, response, loginUserGroupPermissions;
                  if (loginResponse != null) {
                    isVisitor = false;
                    response = LoginResponse.fromJson(loginResponse);
                    if (response.userId ==
                        blogDetailsResponse.healthcareProviderId)
                      isMyBlog = true;
                    else
                      isMyBlog = false;
                    loginUserGroupPermissions =
                        blogDetailsResponse.loginUserGroupPermissions;
                  } else {
                    isVisitor = true;
                    isMyBlog = false;
                  }
                  _showBottomSheet(
                    context: context,
                    isVisitor: isVisitor,
                    isMyBlog: isMyBlog,
                    loginUserGroupPermissions: loginUserGroupPermissions,
                  );
                }),
          ],
        );
      },
    );
  }

  Widget showComments() {
    return ListView.builder(
      itemBuilder: (ee, i) {
        GlobalKey btnKey = GlobalKey();
        return InkWell(
          onLongPress: () {
            if (GlobalPurposeFunctions.getUserObject() == null) {} else
            if (GlobalPurposeFunctions
                .getUserObject()
                .userId ==
                comments[i].personId) {
              menu.dismiss();
              selectedIndex = i;
              menu = PopupMenu(
                  items: [
                    MenuItem(
                        title: AppLocalizations.of(context).delete,
                        textStyle: mediumMontserrat(
                          color: Colors.black,
                          fontSize: 16,
                        )),
                    MenuItem(
                        title: AppLocalizations.of(context).update,
                        textStyle: mediumMontserrat(
                            color: Colors.black, fontSize: 16)),
                    MenuItem(
                        title: AppLocalizations.of(context).report,
                        textStyle: mediumMontserrat(
                            color: Colors.black, fontSize: 16)),
                  ],
                  maxColumn: 1,
                  backgroundColor: Colors.grey.shade300,
                  context: context,
                  onClickMenu: onClickMenu);
            } else {
              menu.dismiss();
              menu = PopupMenu(
                items: [
                  MenuItem(
                      title: AppLocalizations.of(context).report,
                      textStyle:
                      mediumMontserrat(color: Colors.black, fontSize: 16)),
                ],
                maxColumn: 1,
                context: context,
                backgroundColor: Colors.grey.shade300,
                onClickMenu: onClickMenu,
                onDismiss: onDismiss,
              );
            }
            menu.show(widgetKey: btnKey);
          },
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => BlogsDetailReplayScreen(
                            commentId: comments[i].id,
                            userInfo: GlobalPurposeFunctions.getUserObject(),
                          )))
                  .then((value) {
                blogDetailsBloc.add(FetchBlogDetailsEvent(
                  blogId: widget.blogId,
                ));
              });
            },
            child: CommentItem(
              key: btnKey,
              comment: comments[i],
            ),
          ),
        );
      },
      itemCount: comments.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 45),
    );
  }

  Widget showBodyText() {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: AutoDirection(
            text: blogDetailsResponse.body,
            child: Html(
              data: blogDetailsResponse.body,
            ),
          )),
    );
  }

  Widget showButtomReaction() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
            SharedPreferences prefs = serviceLocator<SharedPreferences>();
            var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
            if (loginResponse != null)
              blogDetailsBloc.add(VoteUsefulEvent(
                itemId: blogDetailsResponse.id,
                status: !blogDetailsResponse.markedAsUseful,
              ));
            else
              showDialog(
                context: context,
                builder: (context) => NeedsLoginDialog(),
              );
          },
          child: Row(
            children: [
              SvgPicture.asset(
                blogDetailsResponse.markedAsUseful
                    ? "assets/images/ic_useful_clicked.svg"
                    : "assets/images/ic_useful_not_clicked.svg",
                color: Theme.of(context).primaryColor,
                fit: BoxFit.cover,
                width: 17,
                height: 17,
                alignment: Alignment.center,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                blogDetailsResponse.usefulCount.toString(),
                style: lightMontserrat(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            SharedPreferences prefs = serviceLocator<SharedPreferences>();
            var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
            if (loginResponse != null) {
              var response = LoginResponse.fromJson(loginResponse);
              if (response.userType == 0 || response.userType == 1)
                blogDetailsBloc.add(VoteEmphasisEvent(
                  itemId: blogDetailsResponse.id,
                  status: !blogDetailsResponse.markedAsEmphasis,
                ));
              else
                GlobalPurposeFunctions.showToast(
                    AppLocalizations
                        .of(context)
                        .only_health_care_can_set_emphasis,
                    context);
            } else
              showDialog(
                context: context,
                builder: (context) => NeedsLoginDialog(),
              );
          },
          child: Row(
            children: [
              SvgPicture.asset(
                blogDetailsResponse.markedAsEmphasis
                    ? "assets/images/fill_favorite.svg"
                    : "assets/images/favorite.svg",
                color: Theme.of(context).primaryColor,
                fit: BoxFit.cover,
                width: 20,
                height: 20,
                alignment: Alignment.center,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                blogDetailsResponse.emphasisCount.toString(),
                style: lightMontserrat(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/ic_comment.svg",
              color: Theme.of(context).primaryColor,
              fit: BoxFit.cover,
              width: 17,
              height: 17,
              alignment: Alignment.center,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              comments.length.toString(),
              style: lightMontserrat(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.visibility_outlined,
              color: Theme.of(context).primaryColor,
              size: 17,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              blogDetailsResponse.viewsCount.toString(),
              style: lightMontserrat(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            GlobalPurposeFunctions.share(
                context, "${Urls.SHARE_BLOGS}${widget.blogId}");
          },
          child: Row(
            children: [
              Icon(
                Icons.share,
                size: 17,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                AppLocalizations.of(context).share,
                style: lightMontserrat(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget showImage() {
    return Container(
      margin: EdgeInsets.only(right: 10, top: 10, left: 10),
      width: 70,
      height: 70,
      child: Container(
        child: (blogDetailsResponse.photoUrl != null &&
            blogDetailsResponse.photoUrl != "")
            ? ChachedNetwrokImageView(
                isCircle: true,
                imageUrl: blogDetailsResponse.photoUrl,
              )
            : SvgPicture.asset(
                "assets/images/ic_user_icon.svg",
                color: Theme.of(context).primaryColor,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget buttonSend() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, right: 10),
      child: IconButton(
        icon: Icon(Icons.send),
        color: Theme.of(context).primaryColor,
        tooltip: "إرسال",
        onPressed: () async {},
      ),
    );
  }

  Widget addCommectTextField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CommentTextField(
        cancelUpdate: () {
          _commentController.text = "";
          blogDetailsBloc.add(IsUpdateClickEvent(state: false));
        },
        commentController: _commentController,
        isUpdateClickIcon: isUpdateClickIcon,
        sendMessage: sendAddOrUpdate,
      ),
    );
  }

  void sendAddOrUpdate() {
    if (isUpdateClickIcon) {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      blogDetailsBloc.add(UpdateComment(
          comment: _commentController.text,
          postId: widget.blogId,
          selectCommentIndex: selectedIndex,
          commentId: comments[selectedIndex].id));
    } else {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      blogDetailsBloc.add(AddNewComment(
          comment: _commentController.text, postId: widget.blogId));
    }
  }

  Widget _handleAttachment(int blogType, bool play) {
    switch (blogType) {
      case 1:
        return _handleAttachmentImages();
        break;
      case 2:
        return _handleAttachmentVideos(play);
        break;
      case 3:
        return _handleAttachmentSounds();
        break;
      case 4:
        return _handleAttachmentDocuments();
        break;
      case 5:
        return _handleAttachmentAll();
        break;
      default:
        return Padding(padding: EdgeInsets.all(0));
    }
  }

  Widget _handleAttachmentImages() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(PhotoViewScreen.routeName,
            arguments: blogDetailsResponse.files);
      },
      child: (blogDetailsResponse.files.length == 1)
          ? CachedNetworkImage(
        imageUrl:
        Urls.BASE_URL + blogDetailsResponse.files
            .elementAt(0)
            .url,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
              child:
              CircularProgressIndicator(value: downloadProgress.progress),
              ),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            )
          : (blogDetailsResponse.files.length == 2)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      imageUrl: Urls.BASE_URL +
                          blogDetailsResponse.files
                              .elementAt(0)
                              .url,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                          Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) =>
                      new Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: (MediaQuery.of(context).size.width / 2.1),
                    ),
                    CachedNetworkImage(
                      imageUrl: Urls.BASE_URL +
                          blogDetailsResponse.files
                              .elementAt(1)
                              .url,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                          Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) =>
                      new Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: (MediaQuery.of(context).size.width / 2.1),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      imageUrl: Urls.BASE_URL +
                          blogDetailsResponse.files
                              .elementAt(0)
                              .url,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                          Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) =>
                      new Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: (MediaQuery.of(context).size.width / 2.1),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2), BlendMode.darken),
                          child: CachedNetworkImage(
                            imageUrl: Urls.BASE_URL +
                                blogDetailsResponse.files
                                    .elementAt(1)
                                    .url,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: (MediaQuery.of(context).size.width / 2.1),
                          ),
                        ),
                        Text(
                          '+' +
                              (blogDetailsResponse.files.length - 2).toString(),
                          style: boldMontserrat(
                            fontSize: 50.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }

  Widget _handleAttachmentVideos(bool play) {
    return (blogDetailsResponse.files.elementAt(0).fileType == 0)
        ? VideoWidget(
            play: play,
            url: Urls.BASE_URL + blogDetailsResponse.files.elementAt(0).url,
          )
        : Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  child: ChachedNetwrokImageView(
                      showFullImageWhenClick: false,
                      function: () {
                        GlobalPurposeFunctions.launchURL(
                            url: blogDetailsResponse.files
                                .elementAt(0)
                                .url);
                      },
                      withBaseUrl: false,
                      imageUrl: blogDetailsResponse.files
                          .elementAt(0)
                          .url
                          .contains('?v')
                          ? "http://img.youtube.com/vi/" +
                          blogDetailsResponse.files
                              .elementAt(0)
                              .url
                              .substring(blogDetailsResponse.files
                              .elementAt(0)
                              .url
                              .lastIndexOf('=') +
                              1) +
                              "/hqdefault.jpg"
                          : "http://img.youtube.com/vi/" +
                          blogDetailsResponse.files
                              .elementAt(0)
                              .url
                              .substring(blogDetailsResponse.files
                              .elementAt(0)
                              .url
                              .lastIndexOf('/') +
                              1) +
                              "/hqdefault.jpg",
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width),
                  onTap: () {
                    GlobalPurposeFunctions.launchURL(
                        url: blogDetailsResponse.files.elementAt(0).url);
                  },
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      "assets/images/ic_youtube.svg",
                      color: Colors.white,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 1.0, left: 4.0, right: 4.0),
                    child: Text("Youtube",
                        style: boldMontserrat(
                          color: Colors.white,
                          fontSize: 13,
                        )),
                  ),
                ),
              ),
            ],
          );
  }

  Widget _handleAttachmentSounds() {
    return Container(
      child: Text("Sounds"),
      height: 200,
      alignment: Alignment.center,
    );
  }

  Widget _handleAttachmentDocuments() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file_sharp,
                color: Theme.of(context).primaryColor,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Blog files:',
                style: lightMontserrat(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {
                BlocProvider.of<BlogDetailsBloc>(context).add(DownloadFileEvent(
                    url: Urls.BASE_URL + blogDetailsResponse.files[index].url,
                    fileName: blogDetailsResponse.files[index].name));
                GlobalPurposeFunctions.showToast(
                    AppLocalizations
                        .of(context)
                        .the_file_is_downloading,
                    context);
              },
              child: DocumentFileItem(
                  file: blogDetailsResponse.files[index],
                  index: index,
                  filesLength: blogDetailsResponse.files.length),
            ),
            itemCount: blogDetailsResponse.files.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ],
    );
  }

  Widget _handleAttachmentAll() {
    return Container(
      child: Text(AppLocalizations.of(context).all),
      height: 200,
      alignment: Alignment.center,
    );
  }

  Future _showBottomSheet({
    @required BuildContext context,
    @required bool isVisitor,
    @required bool isMyBlog,
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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
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
                          padding: EdgeInsets.only(
                              right: 10, bottom: 10, top: 10, left: 10),
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
                        padding: ((!isVisitor &&
                                    CheckPermissions.checkEditBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ?const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: ((!isVisitor &&
                                    CheckPermissions.checkEditBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).edit_blog,
                                    style: lightMontserrat(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                        padding: ((!isVisitor &&
                                    CheckPermissions.checkRemoveBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ?const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: ((!isVisitor &&
                                    CheckPermissions.checkRemoveBlogPermission(
                                        loginUserGroupPermissions)) ||
                                isMyBlog)
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).delete_blog,
                                    style: lightMontserrat(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                        padding: !isVisitor
                            ?const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: !isVisitor
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppLocalizations
                                        .of(context)
                                        .report_about_this_blog,
                                    style: lightMontserrat(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            GlobalPurposeFunctions.share(
                                context, Urls.SHARE_BLOGS + widget.blogId);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context).share_blog_link,
                                style: lightMontserrat(
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
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
