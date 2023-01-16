import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/doctor_dialog_info.dart';
import 'package:arachnoit/presentation/custom_widgets/report_dialog.dart';
import 'package:arachnoit/presentation/custom_widgets/user_dialog_info.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question.dart';
import 'package:arachnoit/presentation/screens/add_question/add_question_screen.dart';
import 'package:auto_direction/auto_direction.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/qaa_list_item/qaa_list_item_bloc.dart';
import '../../common/check_permissions.dart';
import '../../common/global_prupose_functions.dart';
import '../../common/pref_keys.dart';
import '../../infrastructure/api/urls.dart';
import '../../infrastructure/common_response/file_response.dart';
import '../../infrastructure/home_qaa/response/qaa_response.dart';
import '../../infrastructure/login/response/login_response.dart';
import '../../injections.dart';
import '../screens/question_details/question_details_screen.dart';
import 'need_make_signup_or_login.dart';
import 'needs_login_dialog.dart';
import 'post_tag_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QaaPostListItem extends StatefulWidget {
  QaaPostListItem({Key key, @required this.post, @required this.deleteItemFunction})
      : super(key: key);

  QaaResponse post;
  final Function deleteItemFunction;

  @override
  _QaaPostListItemState createState() => _QaaPostListItemState();
}

class _QaaPostListItemState extends State<QaaPostListItem> {
  QaaListItemBloc qaaListItemBloc;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    qaaListItemBloc = serviceLocator<QaaListItemBloc>();
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return BlocProvider(
      create: (context) => qaaListItemBloc,
      child: BlocListener<QaaListItemBloc, QaaListItemState>(
        listener: (context, state) {
          if (state is GetBriedProfileSuceess) {
            if (state.profileInfo.accountType == 0 || state.profileInfo.accountType == 1) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                showDialog(
                  context: context,
                  builder: (context) => DoctorDialogInfo(
                    info: state.profileInfo,
                  ),
                );
              });
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) {
                showDialog(
                  context: context,
                  builder: (context) => UserDialogInfo(
                    info: state.profileInfo,
                  ),
                );
              });
            }
          } else if (state is SendReportSuccess) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            Navigator.pop(context);
            Navigator.pop(context);
          } else if (state is FailedSendReport) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            GlobalPurposeFunctions.showToast(
                AppLocalizations.of(context).check_your_internet_connection, context);
          } else if (state is VoteUsefulState) {
            if (widget.post.markedAsUseful)
              widget.post.usefulCount -= 1;
            else
              widget.post.usefulCount += 1;
            widget.post.markedAsUseful = !widget.post.markedAsUseful;
          } else if (state is LoadingState) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          } else if (state is QuestionFilesState) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false).then((value) =>
                showAttachmentsdialog(
                    context: context,
                    qaaListItemBloc: BlocProvider.of<QaaListItemBloc>(context),
                    files: state.questionFiles));
          } else if (state is UpdateObjectWhenSuccessUpdateState) {
            widget.post = state.qaaResponse;
          }
        },
        child: BlocBuilder<QaaListItemBloc, QaaListItemState>(
          builder: (context, state) {
            return Card(
              elevation: 0.0,
              child: InkWell(
                onTap: () {
                  if (GlobalPurposeFunctions.getUserObject() == null) {
                    showDialog(
                      context: context,
                      builder: (context) => NeedMakeSignupOrLogin(),
                    );
                    // GlobalPurposeFunctions.showToast(
                    //     AppLocalizations.of(context).,
                    //     context);
                  } else {
                    Navigator.of(context).pushNamed(QuestionDetailsScreen.routeName,
                        arguments: widget.post.questionId);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 10, left: 10),
                          width: 50,
                          height: 50,
                          child: Container(
                            child: (widget.post.photoUrl != null &&
                                    widget.post.photoUrl != "" &&
                                    !widget.post.askAnonymously)
                                ? ChachedNetwrokImageView(
                                    isCircle: true,
                                    imageUrl: widget.post.photoUrl,
                                  )
                                : SvgPicture.asset(
                                    "assets/images/ic_user_icon.svg",
                                    color: Theme.of(context).primaryColor,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: InkWell(
                                  child: Text(
                                    widget.post.askAnonymously
                                        ? AppLocalizations.of(context).anonymous
                                        : widget.post.firstName + widget.post.lastName,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.visible,
                                    style: mediumMontserrat(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    if (widget.post.askAnonymously) {
                                    } else {
                                      qaaListItemBloc.add(GetProfileBridEvent(
                                          userId: widget.post.personId, context: context));
                                    }
                                  },
                                ),
                              ),
                              if (widget.post.groupId != null && widget.post.groupId != "")
                                Transform.rotate(
                                  angle: 90 * math.pi / 180,
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.more_horiz),
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                              var isVisitor, isMyQuestion, response, loginUserGroupPermissions;
                              if (loginResponse != null) {
                                isVisitor = false;
                                response = LoginResponse.fromJson(loginResponse);
                                if (response.userId == widget.post.personId)
                                  isMyQuestion = true;
                                else
                                  isMyQuestion = false;
                                loginUserGroupPermissions = widget.post.loginUserGroupPermissions;
                              } else {
                                isVisitor = true;
                                isMyQuestion = false;
                              }
                              _showBottomSheet(
                                context: context,
                                isVisitor: isVisitor,
                                isMyQuestion: isMyQuestion,
                                loginUserGroupPermissions: loginUserGroupPermissions,
                                questionId: widget.post.questionId,
                              );
                            })
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 75, right: 75),
                      child: Transform.translate(
                        offset: Offset(0, -10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (widget.post.groupId != null && widget.post.groupId != "")
                                ? Container(
                                    child: InkWell(
                                      child: Text(
                                        widget.post.groupName,
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        style: mediumMontserrat(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  )
                                : Padding(padding: EdgeInsets.all(0)),
                            if (!widget.post.askAnonymously && widget.post.specification != null)
                              Container(
                                  child: Text(
                                widget.post.specification,
                                textAlign: TextAlign.start,
                                style: lightMontserrat(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                              )),
                            if (!widget.post.askAnonymously)
                              SizedBox(
                                height: 5,
                              ),
                            if (!widget.post.askAnonymously && widget.post.subSpecification != null)
                              Container(
                                  child: Text(
                                widget.post.subSpecification,
                                textAlign: TextAlign.start,
                                style: lightMontserrat(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                              )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: AutoDirection(
                          text: widget.post.questionTitle,
                          child: Text(
                            widget.post.questionTitle,
                            style: mediumMontserrat(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          DateFormat.yMd('en').format(DateTime.parse(widget.post.creationDate)),
                          style: lightMontserrat(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          widget.post.category,
                          style: regularMontserrat(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        )),
                    widget.post.subCategories.length == 0
                        ? Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              widget.post.subCategory,
                              style: regularMontserrat(
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ))
                        : Padding(
                            padding: EdgeInsets.only(top: 3, left: 12, right: 12),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: widget.post.subCategories.map((e) {
                                counter++;
                                String addToOrigin =
                                    ((counter) != widget.post.subCategories.length) ? " / " : "";
                                return Text(
                                  e.name + addToOrigin,
                                  style: regularMontserrat(
                                    fontSize: 11,
                                    color: Colors.black,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                    Row(
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: AutoDirection(
                                    text: widget.post.questionBody,
                                    child: Html(
                                      data: widget.post.questionBody.length >= 50
                                          ? widget.post.questionBody.substring(0, 49)+
                                              " " +
                                              AppLocalizations.of(context).read_more
                                          : widget.post.questionBody +
                                              " " +
                                              AppLocalizations.of(context).read_more,
                                      style: {
                                        "*": Style(
                                            fontSize: FontSize.medium,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)
                                      },
                                    )))),
                      ],
                    ),
                    if (widget.post.tags.length != 0)
                      Container(
                        height: 40,
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return PostTagItem(
                              tagName: widget.post.tags[index].name,
                            );
                          },
                          itemCount: widget.post.tags.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                widget.post.usefulCount.toString() +
                                    '\t' +
                                    AppLocalizations.of(context).useful,
                                style: lightMontserrat(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.visible,
                              )),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              widget.post.answersCount.toString() +
                                  '\t' +
                                  AppLocalizations.of(context).answers,
                              style: lightMontserrat(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.visible,
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              widget.post.attachmentsCount.toString() +
                                  '\t' +
                                  AppLocalizations.of(context).attachments,
                              style: lightMontserrat(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.visible,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      thickness: 0.5,
                      endIndent: 10,
                      indent: 10,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var loginResponse = prefs.getString(PrefsKeys.LOGIN_RESPONSE);
                              if (loginResponse != null)
                                BlocProvider.of<QaaListItemBloc>(context).add(VoteUsefulEvent(
                                  itemId: widget.post.questionId,
                                  status: !widget.post.markedAsUseful,
                                ));
                              else
                                showDialog(
                                  context: context,
                                  builder: (context) => NeedsLoginDialog(),
                                );
                            },
                            child: Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
                                    child: SvgPicture.asset(
                                      widget.post.markedAsUseful
                                          ? "assets/images/ic_useful_clicked.svg"
                                          : "assets/images/ic_useful_not_clicked.svg",
                                      color: Theme.of(context).primaryColor,
                                      fit: BoxFit.cover,
                                      width: 20,
                                      height: 20,
                                      alignment: Alignment.center,
                                    )),
                                SizedBox(width: 7),
                                Text(
                                  AppLocalizations.of(context).useful,
                                  style: lightMontserrat(fontSize: 14, color: Colors.black54),
                                ),
                                SizedBox(width: 4)
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/ic_comment.svg",
                                  color: Theme.of(context).primaryColor,
                                  fit: BoxFit.cover,
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  AppLocalizations.of(context).answers,
                                  style: lightMontserrat(fontSize: 14, color: Colors.black54),
                                ),
                                SizedBox(width: 2)
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              if (widget.post.attachmentsCount > 0) {
                                BlocProvider.of<QaaListItemBloc>(context)
                                    .add(GetQuestionFilesEvent(questionId: widget.post.questionId));
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
                                  child: Icon(
                                    Icons.attachment_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(width: 7),
                                Text(
                                  AppLocalizations.of(context).attachments,
                                  style: lightMontserrat(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(width: 4)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future _showBottomSheet({
    @required BuildContext context,
    @required bool isVisitor,
    @required bool isMyQuestion,
    @required List<int> loginUserGroupPermissions,
    @required String questionId,
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
                                AppLocalizations.of(context).more_options,
                                style: mediumMontserrat(
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
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => AddQuestion(
                                                questionId: questionId,
                                                groupId: widget.post.groupId,
                                                isUpdateQuestion: true,
                                                item: widget.post,
                                              )))
                                      .then((value) {
                                    if (value != null) {
                                      qaaListItemBloc
                                          .add(UpdateObjectWhenSuccessUpdate(qaaResponse: value));
                                    }
                                  });
                                  // Navigator.of(context)
                                  //     .pushNamed(AddQuestionScreen.routeName, arguments: {
                                  //   'questionId': questionId,
                                  //   'groupId': widget.post.groupId,
                                  // });
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
                            ? InkWell(
                                onTap: widget.deleteItemFunction,
                                child: Row(
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
                                ),
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ),
                      Padding(
                        padding: !isVisitor
                            ? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)
                            : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: !isVisitor
                            ? InkWell(
                                onTap: () {
                                  print("the conte';c,as';22 ${_controller.text}");

                                  _controller.text = "";
                                  showDialog(
                                    context: context,
                                    builder: (context) => ReportDialog(
                                      userInfo: GlobalPurposeFunctions.getUserObject(),
                                      reportFunction: () {
                                        GlobalPurposeFunctions.showOrHideProgressDialog(
                                            context, true);
                                        qaaListItemBloc.add(SendReport(
                                            blogId: widget.post.questionId,
                                            description: _controller.text));
                                      },
                                      reportController: _controller,
                                    ),
                                  );
                                },
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
                                      AppLocalizations.of(context).report_about_this_question,
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
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            GlobalPurposeFunctions.share(
                                context, Urls.SHARE_HOME_QAA + widget.post.questionId);
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
                                AppLocalizations.of(context).share_question_link,
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

  showAttachmentsdialog(
      {BuildContext context, QaaListItemBloc qaaListItemBloc, List<FileResponse> files}) {
    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: qaaListItemBloc,
              child: BlocBuilder<QaaListItemBloc, QaaListItemState>(
                builder: (buildContext, state) {
                  return Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Text(
                            AppLocalizations.of(context).attachments,
                            textAlign: TextAlign.start,
                            style: lightMontserrat(
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          itemBuilder: (BuildContext context, int index) => InkWell(
                            onTap: () {
                              BlocProvider.of<QaaListItemBloc>(context).add(DownloadFileEvent(
                                  url: Urls.BASE_URL + files[index].url,
                                  fileName: files[index].name));
                              Navigator.of(context).pop();
                              GlobalPurposeFunctions.showToast(
                                  AppLocalizations.of(context).the_file_is_downloading, context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                files[index].name,
                                textAlign: TextAlign.center,
                                style: lightMontserrat(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          itemCount: files.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
  }
}
