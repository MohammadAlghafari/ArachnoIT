import 'dart:async';
import 'package:arachnoit/application/blog_replay_detail/blog_replay_comment_item_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_reply_response.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/blog_comment_item.dart';
import 'package:arachnoit/presentation/custom_widgets/blog_replay_comment.dart';
import 'package:arachnoit/presentation/custom_widgets/comment_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/pop_up_menu.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/report_dialog.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BlogsDetailReplayScreen extends StatefulWidget {
  final String commentId;
  final LoginResponse userInfo;

  BlogsDetailReplayScreen({@required this.commentId, @required this.userInfo});
  @override
  State<StatefulWidget> createState() {
    return _BlogsDetailCommentScreen();
  }
}

class _BlogsDetailCommentScreen extends State<BlogsDetailReplayScreen>
    with TickerProviderStateMixin {
  PopupMenu menu;
  BlogReplayDetailBloc blogReplayCommentItemBloc;
  List<CommentReplyResponse> _comment = [];
  TextEditingController _commentController;
  bool isUpdateClickIcon = false;
  CommentResponse _commentResponse = CommentResponse(id: "-1");
  int _selectedIndex = 0;
  int lastSelectedUpdateIndex = 0;
  ScrollController controller;
  RefreshController refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    blogReplayCommentItemBloc = serviceLocator();
    blogReplayCommentItemBloc.add(FetchAllComment(
      commentId: widget.commentId,
    ));
    _commentController = TextEditingController();
    menu = PopupMenu(
      items: [
        MenuItem(
            title: 'Delete',
            textStyle: mediumMontserrat(
              color: Colors.black,
              fontSize: 16,
            )),
        MenuItem(
            title: 'Update',
            textStyle: mediumMontserrat(color: Colors.black, fontSize: 16)),
        MenuItem(
            title: 'Report',
            textStyle: mediumMontserrat(color: Colors.black, fontSize: 16)),
      ],
      maxColumn: 1,
      context: context,
      backgroundColor: Colors.white.withOpacity(0.8),
      onClickMenu: onClickMenu,
      onDismiss: onDismiss,
    );
  }

  @override
  void dispose() {
    super.dispose();
    menu.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        context: context,
        title: AppLocalizations.of(context).comments,
      ),
      body: BlocProvider(
        create: (context) => blogReplayCommentItemBloc,
        child: BlocListener<BlogReplayDetailBloc, BlogReplayDetailState>(
          listener: (context, state) {
            if (state is SuccessGetAllComments) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
            if (state is SendReportSuccess) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                GlobalPurposeFunctions.showToast(state.message, context);
                Navigator.pop(context);
              });
            } else if (state is FailedSendReport) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast(state.message, context);
            } else if (state is IsUpdateClickState) {
              if (state.state) {
                lastSelectedUpdateIndex = _selectedIndex;
                _commentController.text = _comment[_selectedIndex - 1].body;
              } else {
                lastSelectedUpdateIndex = 0;
                _commentController.text = "";
              }
              isUpdateClickIcon = state.state;
            } else if (state is SuccessGetAllComments) {
              _comment = state.comment.replies;
              _commentResponse = state.comment;
            } else if (state is SuccessAddReplay) {
              _commentController.text = "";
              _comment.add(state.blogCommentReplyResponse);
              Timer(Duration(milliseconds: 500), () {
                controller.animateTo(controller.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              });
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            } else if (state is SuccessUpdateReplay) {
              isUpdateClickIcon = false;
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              _comment[state.index].body = _commentController.text;
              _commentController.text = "";
            } else if (state is SuccessDeleteReplay) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              _comment.removeAt(state.index);
            } else if (state is ErrorState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast(state.errorMessage, context);
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<BlogReplayDetailBloc, BlogReplayDetailState>(
            builder: (context, state) {
              if (_commentResponse.id != "-1") {
                return showInfo();
              }
              if (state is LoadingState) {
                return LoadingBloc();
              }
              if (state is RemoteValidationErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.validationError,
                  function: () {
                    blogReplayCommentItemBloc.add(FetchAllComment(
                      commentId: widget.commentId,
                    ));
                  },
                );
              } else if (state is RemoteServerErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.serverError,
                  function: () {
                    blogReplayCommentItemBloc.add(FetchAllComment(
                      commentId: widget.commentId,
                    ));
                  },
                );
              } else if (state is RemoteClientErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    blogReplayCommentItemBloc.add(FetchAllComment(
                      commentId: widget.commentId,
                    ));
                  },
                );
              } else {
                return showInfo();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showInfo() {
    return Stack(
      children: [
        RefreshData(
          onRefresh: () {
            blogReplayCommentItemBloc.add(FetchAllComment(
              commentId: widget.commentId,
              isRefreshData: true,
            ));
          },
          refreshController: refreshController,
          body: ListView.builder(
              shrinkWrap: true,
              controller: controller,
              padding: EdgeInsets.only(bottom: 45),
              itemCount: _comment.length + 1,
              itemBuilder: (context, index) {
                GlobalKey _btnKey = new GlobalKey();
                if (index == 0)
                  return showOriginCommentInfo();
                else
                  return showItems(index, _btnKey);
              }),
        ),
        addCommectTextField()
      ],
    );
  }

  Widget showOriginCommentInfo() {
    return Column(
      children: [
        CommentItem(
          comment: _commentResponse,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: AutoDirection(
                text: "hello",
                child: Text(
                  "${AppLocalizations
                      .of(context)
                      .comments}(" +
                      _comment.length.toString() +
                      ")",
                  style: semiBoldMontserrat(
                    fontSize: 17,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              )),
        ),
        SizedBox(height: 5),
        Divider(
          color: Theme.of(context).primaryColor,
          endIndent: 15,
          indent: 15,
          thickness: 0.6,
        ),
      ],
    );
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    if (item.menuTitle == AppLocalizations.of(context).delete) {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      blogReplayCommentItemBloc.add(DeleteReplay(
          selectCommentIndex: _selectedIndex - 1,
          commentId: _comment[_selectedIndex - 1].id));
    } else if (item.menuTitle == AppLocalizations.of(context).update) {
      _commentController.text = _comment[_selectedIndex - 1].body;
      blogReplayCommentItemBloc.add(IsUpdateClickEvent(state: true));
    } else if (item.menuTitle == AppLocalizations.of(context).report) {
      TextEditingController _controller = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => ReportDialog(
          userInfo: widget.userInfo,
          reportFunction: () {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            blogReplayCommentItemBloc.add(SendReport(
              commentId: _comment[_selectedIndex].id,
              description: _controller.text,
            ));
          },
          reportController: _controller,
        ),
      );
    }
  }

  void onDismiss() {}

  Widget showItems(int index, GlobalKey globalKey) {
    bool isArabic =
    Localizations.localeOf(context).toString() == 'ar' ?true : false;
    return Padding(
      padding: EdgeInsets.only(
        left: (isArabic) ? 0 : 18,
        top: 5,
        right: (!isArabic) ? 0 : 18,
      ),
      child: InkWell(
        onLongPress: () {
          if (widget.userInfo.userId == _comment[index - 1].personId) {
            _selectedIndex = index;
            menu.dismiss();
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
                    textStyle:
                    mediumMontserrat(color: Colors.black, fontSize: 16)),
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
          menu.show(widgetKey: globalKey);
        },
        child: ReplyCommentItem(
          key: globalKey,
          comment: _comment[index - 1],
        ),
      ),
    );
  }

  Widget addCommectTextField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CommentTextField(
        cancelUpdate: () {
          blogReplayCommentItemBloc.add(IsUpdateClickEvent(state: false));
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
      blogReplayCommentItemBloc.add(UpdateReplay(
          comment: _commentController.text,
          postId: widget.commentId,
          selectCommentIndex: lastSelectedUpdateIndex - 1,
          commentId: _comment[lastSelectedUpdateIndex - 1].id));
    } else {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      blogReplayCommentItemBloc.add(AddNewReplay(
          comment: _commentController.text, postId: widget.commentId));
    }
  }
}
