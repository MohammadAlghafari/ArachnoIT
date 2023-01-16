import 'dart:async';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_response.dart';
import 'package:arachnoit/infrastructure/question_details/response/question_details_response.dart';
import 'package:arachnoit/presentation/custom_widgets/blog_replay_comment.dart';
import 'package:arachnoit/presentation/custom_widgets/comment_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/qaa_answer_item.dart';
import 'package:arachnoit/presentation/custom_widgets/report_dialog.dart';
import 'package:arachnoit/presentation/screens/qustion_replay_answer_item/question_replay_answer_item_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:arachnoit/application/question_replay_details/question_replay_details_bloc.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_reply_response.dart';
import 'package:arachnoit/infrastructure/common_response/blog_comment_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/blog_comment_item.dart';
import 'package:arachnoit/presentation/custom_widgets/pop_up_menu.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class QuestionDetailReplayScreen extends StatefulWidget {
  final String answerId;
  final LoginResponse userInfo;
  final String questionId;

  QuestionDetailReplayScreen(
      {@required this.answerId, @required this.userInfo, @required this.questionId});

  @override
  State<StatefulWidget> createState() {
    return _QuestionDetailCommentScreen();
  }
}

class _QuestionDetailCommentScreen extends State<QuestionDetailReplayScreen>
    with TickerProviderStateMixin {
  PopupMenu menu;
  QuestionReplayDetailsBloc questionReplayDetailBloc;
  List<QuestionAnswerCommentResponse> questionReplayComments = [];
  TextEditingController _commentController;
  bool isUpdateClickIcon = false;
  QuestionAnswerResponse _questionCommentResponse = QuestionAnswerResponse(personId: "-1");
  int _selectedIndex = 0;
  int lastSelectedUpdateIndex = 0;
  ScrollController controller;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    controller = ScrollController();
    questionReplayDetailBloc = serviceLocator();
    questionReplayDetailBloc
        .add(FetchAllComment(answerId: widget.answerId, questionId: widget.questionId));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarProject.showAppBar(context: context, title: AppLocalizations.of(context).comments),
      body: BlocProvider(
        create: (context) => questionReplayDetailBloc,
        child: BlocListener<QuestionReplayDetailsBloc, QuestionReplayDetailsState>(
          listener: (context, state) {
            if (state is SuccessGetAllComments) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
            if (state is SendReportSuccess) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                GlobalPurposeFunctions.showToast(state.message, context);
                Navigator.pop(context);
              });
            } else if (state is FailedSendReport) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast(state.message, context);
            } else if (state is IsUpdateClickState) {
              if (state.state) {
                lastSelectedUpdateIndex = _selectedIndex;
                _commentController.text = questionReplayComments[_selectedIndex - 1].body;
              } else {
                lastSelectedUpdateIndex = 0;
                _commentController.text = "";
              }
              isUpdateClickIcon = state.state;
            } else if (state is SuccessGetAllComments) {
              questionReplayComments = state.comment.comments;
              _questionCommentResponse = state.comment;
            } else if (state is SuccessAddReplay) {
              _commentController.text = "";
              questionReplayComments.add(state.questionCommentReplyResponse);
              Timer(Duration(milliseconds: 500), () {
                controller.animateTo(controller.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500), curve: Curves.easeIn);
              });
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            } else if (state is SuccessUpdateReplay) {
              isUpdateClickIcon = false;
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              questionReplayComments[state.index].body = _commentController.text;
              _commentController.text = "";
            } else if (state is SuccessDeleteReplay) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              questionReplayComments.removeAt(state.index);
            } else if (state is ErrorState) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast(state.errorMessage, context);
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<QuestionReplayDetailsBloc, QuestionReplayDetailsState>(
            builder: (context, state) {
              if (_questionCommentResponse.personId != "-1") return showInfo();
              if (state is LoadingState) {
                return LoadingBloc();
              }
              if (state is RemoteValidationErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.validationError,
                  function: () {
                    questionReplayDetailBloc.add(
                        FetchAllComment(answerId: widget.answerId, questionId: widget.questionId));
                  },
                );
              } else if (state is RemoteServerErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.serverError,
                  function: () {
                    questionReplayDetailBloc.add(
                        FetchAllComment(answerId: widget.answerId, questionId: widget.questionId));
                  },
                );
              } else if (state is RemoteClientErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    questionReplayDetailBloc.add(
                        FetchAllComment(answerId: widget.answerId, questionId: widget.questionId));
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
            questionReplayDetailBloc.add(FetchAllComment(
                answerId: widget.answerId, questionId: widget.questionId, isRefreshData: true));
          },
          refreshController: refreshController,
          body: ListView.builder(
              shrinkWrap: true,
              controller: controller,
              padding: EdgeInsets.only(bottom: 45),
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: questionReplayComments.length + 1,
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
    GlobalKey btnKey = GlobalKey();
    return Column(
      children: [
        QaaAnswerItem(
          answer: _questionCommentResponse,
          key: btnKey,
        ),
        //   CommentItem(
        //     comment: _commentResponse,
        //   ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: AutoDirection(
                text: "hello",
                child: Text(
                  AppLocalizations.of(context).answers +
                      "(" +
                      questionReplayComments.length.toString() +
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
      questionReplayDetailBloc.add(DeleteReplay(
          selectCommentIndex: _selectedIndex - 1,
          commentId: questionReplayComments[_selectedIndex - 1].commentId));
    } else if (item.menuTitle == AppLocalizations.of(context).update) {
      _commentController.text = questionReplayComments[_selectedIndex - 1].body;
      questionReplayDetailBloc.add(IsUpdateClickEvent(state: true));
    } else if (item.menuTitle == AppLocalizations.of(context).report) {
      TextEditingController _controller = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => ReportDialog(
          userInfo: widget.userInfo,
          reportFunction: () {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            questionReplayDetailBloc.add(SendReport(
              commentId: questionReplayComments[_selectedIndex - 1].commentId,
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
    bool isArabic = Localizations.localeOf(context).toString() == 'ar' ? true : false;
    return Padding(
      padding: EdgeInsets.only(
        left: (isArabic) ? 0 : 18,
        top: 5,
        right: (!isArabic) ? 0 : 18,
      ),
      child: InkWell(
        onLongPress: () {
          if (widget.userInfo.userId == questionReplayComments[index - 1].personId) {
            menu.dismiss();
            _selectedIndex = index;
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
                    textStyle: mediumMontserrat(
                        color: Colors.black, fontSize: 16)),
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
        child: QuestionReplyCommentItem(
          key: globalKey,
          comment: questionReplayComments[index - 1],
          questionAnswerResponse:_questionCommentResponse ,
        ),
      ),
    );
  }

  Widget addCommectTextField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CommentTextField(
        cancelUpdate: () {
          questionReplayDetailBloc.add(IsUpdateClickEvent(state: false));
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
      questionReplayDetailBloc.add(UpdateReplay(
          message: _commentController.text,
          answerId: widget.answerId,
          selectCommentIndex: lastSelectedUpdateIndex - 1,
          replayCommentId: questionReplayComments[lastSelectedUpdateIndex - 1].commentId));
    } else {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      questionReplayDetailBloc
          .add(AddNewReplay(comment: _commentController.text, postId: widget.answerId));
    }
  }
}
