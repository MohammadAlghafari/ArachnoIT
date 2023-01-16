import 'dart:async';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/infrastructure/common_response/file_response.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_response.dart';
import 'package:arachnoit/presentation/custom_widgets/answer_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/comment_text_field.dart';
import 'package:arachnoit/presentation/custom_widgets/document_file_item.dart';
import 'package:arachnoit/presentation/custom_widgets/file_item.dart';
import 'package:arachnoit/presentation/custom_widgets/pop_up_menu.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/report_dialog.dart';
import 'package:arachnoit/presentation/screens/question_details_replay/question_detail_replay_screen.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/question_details/question_details_bloc.dart';
import '../../../common/check_permissions.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../common/pref_keys.dart';
import '../../../infrastructure/api/urls.dart';
import '../../../infrastructure/question_details/response/question_details_response.dart';
import '../../../infrastructure/login/response/login_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/needs_login_dialog.dart';
import '../../custom_widgets/qaa_answer_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionDetailsScreen extends StatefulWidget {
  static const routeName = '/question_details_screen';

  QuestionDetailsScreen({Key key, @required this.questionId, @required this.userInfo})
      : super(key: key);
  final String questionId;
  LoginResponse userInfo;

  @override
  _QuestionDetailsScreenState createState() => _QuestionDetailsScreenState();
}

class _QuestionDetailsScreenState extends State<QuestionDetailsScreen>
    with TickerProviderStateMixin {
  QuestionDetailsBloc questionDetailsBloc;
  TextEditingController _controllerSentReport;
  QuestionDetailsResponse questionDetailsResponse;
  TextEditingController _answerController;
  bool isUpdateClickIcon;
  List<FileResponse> files;
  Map<String, int> wrapFilesItemsIndex = Map<String, int>();
  List<String> removedFiles;
  List<QuestionAnswerResponse> answers = [];
  ScrollController controller;
  int selectedIndex = 0, lastSelectedUpdateIndex = 0;
  PopupMenu menu;
  final key = GlobalKey();
  int userType;

  @override
  void initState() {
    super.initState();
    questionDetailsBloc = serviceLocator<QuestionDetailsBloc>()
      ..add(FetchQuestionDetailsEvent(
        questionId: widget.questionId,
      ));
    _answerController = TextEditingController();
    isUpdateClickIcon = false;
    files = <FileResponse>[];
    removedFiles = <String>[];
    controller = new ScrollController();

    menu = PopupMenu(
      items: [
        MenuItem(
            title: 'Delete',
            textStyle: mediumMontserrat(
              color: Colors.black,
              fontSize: 16,
            )),
        MenuItem(title: 'Update', textStyle: mediumMontserrat(color: Colors.black, fontSize: 16)),
        MenuItem(title: 'Report', textStyle: mediumMontserrat(color: Colors.black, fontSize: 16)),
      ],
      maxColumn: 1,
      backgroundColor: Colors.white.withOpacity(0.8),
    );
    userType = widget?.userInfo?.userType ?? -1;
  }

  RefreshController refreshController = RefreshController();

  @override
  void dispose() {
    super.dispose();
    menu.dismiss();
    _controllerSentReport.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => questionDetailsBloc,
      child: BlocListener<QuestionDetailsBloc, QuestionDetailsState>(
        listener: (context, state) {
          if (state is QuestionDetailsFetchedState) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
          if (state is AnswerUpdatedFileListState) {
            _handleUpdatedFilesState(state);
          } else if (state is SucessAddNewAnswer) {
            _answerController.text = "";

            files = <FileResponse>[];
            answers.insert(0, state.answerResponse);
            Timer(Duration(milliseconds: 500), () {
              controller.animateTo(controller.position.maxScrollExtent,
                  duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            });
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {});
          } else if (state is SuccessDeleteAnswer) {
            lastSelectedUpdateIndex = 0;
            _answerController.text = '';
            isUpdateClickIcon = false;
            answers.removeAt(state.selectAnswerIndex);
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {});
          } else if (state is SendReportSuccess) {
            Navigator.pop(context);
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
              GlobalPurposeFunctions.showToast(state.message, context);
            });
            lastSelectedUpdateIndex = 0;
            _answerController.text = '';
            isUpdateClickIcon = false;
          } else if (state is IsUpdateClickState) {
            if (state.state) {
              lastSelectedUpdateIndex = selectedIndex;
              _answerController.text = answers[selectedIndex].answerBody;
              files = List<FileResponse>.from(answers[selectedIndex].files);
              removedFiles = <String>[];
              questionDetailsBloc.add(
                AnswerUpdateFilesListEvent(
                  files: files,
                ),
              );
            } else {
              lastSelectedUpdateIndex = 0;
              _answerController.text = "";
              files = <FileResponse>[];
              removedFiles = <String>[];
            }
            isUpdateClickIcon = state.state;
          } else if (state is SuccessUpdateAnswerSuccess) {
            answers[state.selectAnswerIndex].answerBody = state.newBody;
            answers[state.selectAnswerIndex].files = state.files;
            lastSelectedUpdateIndex = 0;
            _answerController.text = "";
            isUpdateClickIcon = false;
            files = <FileResponse>[];
            removedFiles = <String>[];
            Timer(Duration(milliseconds: 500), () {
              controller.animateTo(controller.position.maxScrollExtent,
                  duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            });
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {});
          } else if (state is QuestionDetailsFetchedState) {
            questionDetailsResponse = state.questionDetails;
            answers = questionDetailsResponse.answers;
          } else if (state is VoteUsefulState && questionDetailsResponse != null) {
            if (questionDetailsResponse.markedAsUseful)
              questionDetailsResponse.usefulCount -= 1;
            else
              questionDetailsResponse.usefulCount += 1;
            questionDetailsResponse.markedAsUseful = !questionDetailsResponse.markedAsUseful;
          } else if (state is RemoteClientErrorScreenActionState) {
            GlobalPurposeFunctions.showToast(
                AppLocalizations.of(context).error_happened_try_again, context);
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {});
          } else if (state is RemoteServerErrorScreenActionState) {
            GlobalPurposeFunctions.showToast(AppLocalizations.of(context).server_error, context);
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {});
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {});
          }
        },
        child: BlocBuilder<QuestionDetailsBloc, QuestionDetailsState>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBarProject.showAppBar(
                  title: AppLocalizations.of(context).answers,
                ),
                body: state is LoadingState
                    ? LoadingBloc()
                    : questionDetailsResponse != null
                        ? Column(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: RefreshData(
                                  onRefresh: () {
                                    questionDetailsBloc.add(FetchQuestionDetailsEvent(
                                        questionId: widget.questionId, isRefreshData: true));
                                  },
                                  refreshController: refreshController,
                                  body: ListView(controller: controller, children: [
                                    Column(
                                      children: [
                                        Card(
                                          elevation: 0.0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10, top: 10, left: 10),
                                                    width: 70,
                                                    height: 70,
                                                    child: Container(
                                                      child: (questionDetailsResponse.photoUrl !=
                                                                  null &&
                                                              questionDetailsResponse.photoUrl !=
                                                                  "")
                                                          ? ChachedNetwrokImageView(
                                                              imageUrl:
                                                                  questionDetailsResponse.photoUrl,
                                                              isCircle: true,
                                                            )
                                                          : SvgPicture.asset(
                                                              "assets/images/ic_user_icon.svg",
                                                              color: Theme.of(context).primaryColor,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(top: 10),
                                                          child: InkWell(
                                                            child: Text(
                                                              questionDetailsResponse.askAnonymously
                                                                  ? AppLocalizations.of(context)
                                                                      .anonymous
                                                                  : questionDetailsResponse
                                                                          .firstName +
                                                                      questionDetailsResponse
                                                                          .lastName,
                                                              textAlign: TextAlign.start,
                                                              overflow: TextOverflow.visible,
                                                              style: boldCircular(
                                                                color:
                                                                    Theme.of(context).accentColor,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            onTap: () {},
                                                          ),
                                                        ),
                                                        if (!questionDetailsResponse
                                                                .askAnonymously &&
                                                            questionDetailsResponse.specification !=
                                                                null)
                                                          Text(
                                                            questionDetailsResponse.specification,
                                                            textAlign: TextAlign.start,
                                                            style: lightMontserrat(
                                                              fontSize: 11,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        if (!questionDetailsResponse.askAnonymously)
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        if (!questionDetailsResponse
                                                                .askAnonymously &&
                                                            questionDetailsResponse
                                                                    .subSpecification !=
                                                                null)
                                                          Text(
                                                            questionDetailsResponse
                                                                .subSpecification,
                                                            textAlign: TextAlign.start,
                                                            style: lightMontserrat(
                                                              fontSize: 11,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                      icon: Icon(Icons.more_horiz),
                                                      color: Theme.of(context).primaryColor,
                                                      onPressed: () async {
                                                        SharedPreferences prefs =
                                                            await SharedPreferences.getInstance();
                                                        var loginResponse = prefs
                                                            .getString(PrefsKeys.LOGIN_RESPONSE);
                                                        var isVisitor,
                                                            isMyQuestion,
                                                            response,
                                                            loginUserGroupPermissions;
                                                        if (loginResponse != null) {
                                                          isVisitor = false;
                                                          response =
                                                              LoginResponse.fromJson(loginResponse);
                                                          if (response.userId ==
                                                              questionDetailsResponse.personId)
                                                            isMyQuestion = true;
                                                          else
                                                            isMyQuestion = false;
                                                          loginUserGroupPermissions =
                                                              questionDetailsResponse
                                                                  .loginUserGroupPermissions;
                                                        } else {
                                                          isVisitor = true;
                                                          isMyQuestion = false;
                                                        }
                                                        _showBottomSheet(
                                                          context: context,
                                                          isVisitor: isVisitor,
                                                          isMyQuestion: isMyQuestion,
                                                          loginUserGroupPermissions:
                                                              loginUserGroupPermissions,
                                                        );
                                                      })
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Divider(
                                                thickness: 0.5,
                                                color: Colors.black38,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(left: 10, right: 10),
                                                  child: AutoDirection(
                                                    text: questionDetailsResponse.questionTitle,
                                                    child: Text(
                                                      questionDetailsResponse.questionTitle,
                                                      style: semiBoldMontserrat(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(left: 10, right: 10),
                                                  child: Text(
                                                    DateFormat.yMd('en').format(DateTime.parse(
                                                        questionDetailsResponse.creationDate)),
                                                    style: lightMontserrat(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(left: 10, right: 10),
                                                  child: Text(
                                                    questionDetailsResponse.category,
                                                    style: lightMontserrat(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(left: 10, right: 10),
                                                  child: Text(
                                                    questionDetailsResponse.subCategory,
                                                    style: lightMontserrat(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                        margin:
                                                            EdgeInsets.only(left: 10, right: 10),
                                                        child: AutoDirection(
                                                            text: questionDetailsResponse
                                                                .questionBody,
                                                            child: Html(
                                                              data: questionDetailsResponse
                                                                  .questionBody,
                                                              style: {
                                                                "*": Style(
                                                                    fontSize: FontSize.medium,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500)
                                                              },
                                                            )
                                                            /* Text(
                                                              state.questionDetails
                                                              .questionBody
                                                         ,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ), */
                                                            )),
                                                  ),
                                                ],
                                              ),
                                              if (questionDetailsResponse.files.length != 0)
                                                SizedBox(height: 20),
                                              if (questionDetailsResponse.files.length != 0)
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
                                                        AppLocalizations.of(context).question_files,
                                                        style: lightMontserrat(
                                                          color: Theme.of(context).primaryColor,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              if (questionDetailsResponse.files.length != 0)
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              if (questionDetailsResponse.files.length != 0)
                                                Container(
                                                  margin: EdgeInsets.only(left: 10, right: 10),
                                                  child: ListView.builder(
                                                    itemBuilder:
                                                        (BuildContext context, int index) =>
                                                            InkWell(
                                                      onTap: () {
                                                        BlocProvider.of<QuestionDetailsBloc>(
                                                                context)
                                                            .add(DownloadFileEvent(
                                                                url: Urls.BASE_URL +
                                                                    questionDetailsResponse
                                                                        .files[index].url,
                                                                fileName: questionDetailsResponse
                                                                    .files[index].name));
                                                        GlobalPurposeFunctions.showToast(
                                                            AppLocalizations.of(context)
                                                                .the_file_is_downloading,
                                                            context);
                                                      },
                                                      child: DocumentFileItem(
                                                          file:
                                                              questionDetailsResponse.files[index],
                                                          index: index,
                                                          filesLength:
                                                              questionDetailsResponse.files.length),
                                                    ),
                                                    itemCount: questionDetailsResponse.files.length,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Divider(
                                                thickness: 0.2,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences.getInstance();
                                                      var loginResponse =
                                                          prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                                                      if (loginResponse != null)
                                                        BlocProvider.of<QuestionDetailsBloc>(
                                                                context)
                                                            .add(VoteUsefulEvent(
                                                          itemId:
                                                              questionDetailsResponse.questionId,
                                                          status: !questionDetailsResponse
                                                              .markedAsUseful,
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
                                                          questionDetailsResponse.markedAsUseful
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
                                                          questionDetailsResponse.usefulCount
                                                              .toString(),
                                                          style: lightMontserrat(
                                                              fontSize: 14, color: Colors.black54),
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
                                                        questionDetailsResponse.answersCount
                                                            .toString(),
                                                        style: lightMontserrat(
                                                            fontSize: 14, color: Colors.black54),
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
                                                        questionDetailsResponse.viewsCount
                                                            .toString(),
                                                        style: lightMontserrat(
                                                            fontSize: 14, color: Colors.black54),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
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
                                                        style: lightMontserrat(
                                                            fontSize: 14, color: Colors.black54),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              margin: EdgeInsets.only(left: 15, right: 15),
                                              child: AutoDirection(
                                                text: "hello",
                                                child: Text(
                                                  "${AppLocalizations.of(context).answers}(" +
                                                      questionDetailsResponse.answersCount
                                                          .toString() +
                                                      ")",
                                                  style: boldCircular(
                                                    fontSize: 18,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                          color: Theme.of(context).primaryColor,
                                          endIndent: 15,
                                          indent: 15,
                                          thickness: 0.6,
                                        ),
                                        if (questionDetailsResponse.answers.length > 0)
                                          ListView.builder(
                                            itemBuilder: (context, i) {
                                              GlobalKey btnKey = GlobalKey();
                                              return InkWell(
                                                onLongPress: () {
                                                  if (widget.userInfo == null) {
                                                  } else if (widget.userInfo.userId ==
                                                      answers[i].personId) {
                                                    menu.dismiss();
                                                    selectedIndex = i;
                                                    menu = PopupMenu(
                                                      items: [
                                                        MenuItem(
                                                            title:
                                                                AppLocalizations.of(context).delete,
                                                            textStyle: mediumMontserrat(
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                            )),
                                                        MenuItem(
                                                            title:
                                                                AppLocalizations.of(context).update,
                                                            textStyle: mediumMontserrat(
                                                                color: Colors.black, fontSize: 16)),
                                                        MenuItem(
                                                            title:
                                                                AppLocalizations.of(context).report,
                                                            textStyle: mediumMontserrat(
                                                                color: Colors.black, fontSize: 16)),
                                                      ],
                                                      maxColumn: 1,
                                                      backgroundColor: Colors.grey.shade300,
                                                      context: context,
                                                      onClickMenu: onClickMenu,
                                                    );
                                                  } else {
                                                    menu.dismiss();
                                                    menu = PopupMenu(
                                                      items: [
                                                        MenuItem(
                                                            title:
                                                                AppLocalizations.of(context).report,
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
                                                  menu.show(widgetKey: btnKey);
                                                },
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            QuestionDetailReplayScreen(
                                                          answerId: questionDetailsResponse
                                                              .answers[i].answerId,
                                                          userInfo: widget.userInfo,
                                                          questionId:
                                                              questionDetailsResponse.questionId,
                                                        ),
                                                      ),
                                                    )
                                                        .then((value) {
                                                      questionDetailsBloc
                                                          .add(FetchQuestionDetailsEvent(
                                                        questionId: widget.questionId,
                                                      ));
                                                    });
                                                  },
                                                  child: QaaAnswerItem(
                                                    answer: questionDetailsResponse.answers[i],
                                                    key: btnKey,
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: questionDetailsResponse.answers.length,
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            reverse: true,
                                            padding: EdgeInsets.only(bottom: 45),
                                          ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                              /* Container(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5, top: 5),
                              child: TextField(
                                showCursor: false,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                cursorColor: Theme.of(context).accentColor,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.attachment,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.send,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    hintText: "Write your answer here",
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25),
                                    )),
                              ),
                              color: Colors.white,
                            ), */
                              Container(
                                margin: EdgeInsetsDirectional.only(
                                  start: 10.0,
                                  end: 10.0,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadiusDirectional.all(
                                    Radius.circular(
                                      22.0,
                                    ),
                                  ),
                                ),
                                child: showFiles(),
                              ),
                              addAnswerTextField()
                            ],
                          )
                        : (state is RemoteClientErrorState)
                            ? BlocError(
                                blocErrorState: BlocErrorState.userError,
                                function: () {
                                  questionDetailsBloc.add(FetchQuestionDetailsEvent(
                                    questionId: widget.questionId,
                                  ));
                                },
                                context: context)
                            : (state is RemoteServerErrorState)
                                ? BlocError(
                                    blocErrorState: BlocErrorState.serverError,
                                    function: () {
                                      questionDetailsBloc.add(FetchQuestionDetailsEvent(
                                        questionId: widget.questionId,
                                      ));
                                    },
                                    context: context)
                                : Container());
          },
        ),
      ),
    );
  }

  Widget addAnswerTextField() {
    if (userType == -1) {
      return Container();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnswerTextField(
        cancelUpdate: () {
          _answerController.text = "";
          questionDetailsBloc.add(IsUpdateClickEvent(state: false));
        },
        commentController: _answerController,
        isUpdateClickIcon: isUpdateClickIcon,
        sendMessage: sendAddOrUpdate,
        chooseFile: chooseFile,
      ),
    );
  }

  Widget showFiles() {
    return Wrap(
      children: files.map((e) {
        return Padding(
          padding: EdgeInsets.only(top: 4, left: 4, right: 4),
          child: InkWell(
            onTap: () {
              if (files[wrapFilesItemsIndex[e.name]].id != null) {
                removedFiles.add(files[wrapFilesItemsIndex[e.name]].id);
              }
              questionDetailsBloc.add(AnswerRemoveFileItem(
                files: files,
                index: wrapFilesItemsIndex[e.name],
              ));
            },
            child: FileItem(
              fileExtension: e.extension,
              fileName: e.name,
              filePath: e.url,
              fileId: e.id,
            ),
          ),
        );
      }).toList(),
    );
  }

  void onDismiss() {}

  void onClickMenu(MenuItemProvider item) {
    if (item.menuTitle == AppLocalizations.of(context).delete) {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      questionDetailsBloc.add(RemoveAnswerFromQuestion(
          selectAnswerIndex: selectedIndex, answerId: answers[selectedIndex].answerId));
    } else if (item.menuTitle == AppLocalizations.of(context).update) {
      questionDetailsBloc.add(IsUpdateClickEvent(state: true));
    } else if (item.menuTitle == AppLocalizations.of(context).report) {
      _controllerSentReport = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => ReportDialog(
          userInfo: widget.userInfo,
          reportFunction: () {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            questionDetailsBloc.add(SendReport(
              commentId: answers[selectedIndex].answerId,
              description: _controllerSentReport.text,
            ));
          },
          reportController: _controllerSentReport,
        ),
      );
    }
  }

  void sendAddOrUpdate() {
    if (isUpdateClickIcon) {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      questionDetailsBloc.add(
        UpdateAnswer(
          answer: _answerController.text,
          postId: widget.questionId,
          selectAnswerIndex: selectedIndex,
          answerId: answers[selectedIndex].answerId,
          files: files
              .where(
                (element) => element.id == null,
              )
              .toList(),
          removedFiles: removedFiles,
        ),
      );
    } else {
      GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
      questionDetailsBloc.add(
          AddNewAnswer(answer: _answerController.text, files: files, postId: widget.questionId));
    }
    FocusScope.of(context).unfocus();
  }

  void chooseFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<PlatformFile> platformFiles = result.files;
      platformFiles.forEach((element) {
        FileResponse fileResponse = FileResponse();
        fileResponse.url = element.path;
        fileResponse.name = element.name;
        fileResponse.extension = element.extension;
        files.add(fileResponse);
      });

      questionDetailsBloc.add(AnswerUpdateFilesListEvent(
        files: files,
      ));
    }
  }

  void _handleUpdatedFilesState(AnswerUpdatedFileListState state) {
    wrapFilesItemsIndex.clear();
    files = state.files;
    for (int i = 0; i < files.length; i++) {
      wrapFilesItemsIndex[files[i].name] = i;
    }
  }

  Future _showBottomSheet({
    @required BuildContext context,
    @required bool isVisitor,
    @required bool isMyQuestion,
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
                                style: semiBoldMontserrat(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: ((!isVisitor &&
                                    CheckPermissions.checkEditQuestionPermission(
                                        loginUserGroupPermissions)) ||
                                isMyQuestion)
                            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: ((!isVisitor &&
                                    CheckPermissions.checkEditQuestionPermission(
                                        loginUserGroupPermissions)) ||
                                isMyQuestion)
                            ? InkWell(
                                onTap: () {
                                  GlobalPurposeFunctions.share(
                                      context, Urls.SHARE_HOME_QAA + widget.questionId);
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
                                      AppLocalizations.of(context).edit_question,
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
                        padding: ((!isVisitor &&
                                    CheckPermissions.checkRemoveQuestionPermission(
                                        loginUserGroupPermissions)) ||
                                isMyQuestion)
                            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: ((!isVisitor &&
                                    CheckPermissions.checkRemoveQuestionPermission(
                                        loginUserGroupPermissions)) ||
                                isMyQuestion)
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
                                    AppLocalizations.of(context).delete_question,
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
                            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                                    AppLocalizations.of(context).report_about_this_question,
                                    style: lightMontserrat(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      InkWell(
                        onTap: () {
                          GlobalPurposeFunctions.share(
                              context, Urls.SHARE_HOME_QAA + widget.questionId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
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
