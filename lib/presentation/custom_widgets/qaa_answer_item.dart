import 'dart:ui';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/user_dialog_info.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/question_answer_item/question_answer_item_bloc.dart';
import '../../common/global_prupose_functions.dart';
import '../../common/pref_keys.dart';
import '../../infrastructure/api/urls.dart';
import '../../infrastructure/common_response/question_answer_response.dart';
import '../../infrastructure/login/response/login_response.dart';
import '../../injections.dart';
import 'doctor_dialog_info.dart';
import 'document_file_item.dart';
import 'needs_login_dialog.dart';

class QaaAnswerItem extends StatefulWidget {
  const QaaAnswerItem({Key key, @required this.answer}) : super(key: key);

  final QuestionAnswerResponse answer;

  @override
  _QaaAnswerItemState createState() => _QaaAnswerItemState();
}

class _QaaAnswerItemState extends State<QaaAnswerItem> {
  QuestionAnswerItemBloc questionAnswerItemBloc;

  @override
  void initState() {
    super.initState();
    questionAnswerItemBloc = serviceLocator<QuestionAnswerItemBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => questionAnswerItemBloc,
      child: BlocListener<QuestionAnswerItemBloc, QuestionAnswerItemState>(
        listener: (context, state) {
          if (state is GetBriedProfileSuceess) {
            if (state.profileInfo.accountType == 0 ||
                state.profileInfo.accountType == 1) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                showDialog(
                  context: context,
                  builder: (context) => DoctorDialogInfo(
                    info: state.profileInfo,
                  ),
                );
              });
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
                  .then((value) {
                showDialog(
                  context: context,
                  builder: (context) => UserDialogInfo(
                    info: state.profileInfo,
                  ),
                );
              });
            }
          }
          if (state is VoteEmphasisState) {
            if (widget.answer.markedAsEmphasis) {
              widget.answer.emphasisCount -= 1;
              widget.answer.markedAsEmphasis = !widget.answer.markedAsEmphasis;
            } else {
              widget.answer.emphasisCount += 1;
              widget.answer.markedAsEmphasis = !widget.answer.markedAsEmphasis;
              if (!widget.answer.markedAsUseful) {
                widget.answer.usefulCount += 1;
                widget.answer.markedAsUseful = !widget.answer.markedAsUseful;
              }
            }
          } else if (state is VoteUsefulState) {
            if (widget.answer.markedAsUseful) {
              widget.answer.usefulCount -= 1;
              widget.answer.markedAsUseful = !widget.answer.markedAsUseful;
              if (widget.answer.markedAsEmphasis) {
                widget.answer.emphasisCount -= 1;
                widget.answer.markedAsEmphasis =
                !widget.answer.markedAsEmphasis;
              }
            } else {
              widget.answer.usefulCount += 1;
              widget.answer.markedAsUseful = !widget.answer.markedAsUseful;
            }
          }
        },
        child: BlocBuilder<QuestionAnswerItemBloc, QuestionAnswerItemState>(
            builder: (context, state) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  child: (widget.answer.photoUrl != null &&
                          widget.answer.photoUrl != "" &&
                          widget.answer.inTouchPointName != null)
                      ? ChachedNetwrokImageView(
                          imageUrl: widget.answer.photoUrl,
                          isCircle: true,
                        )
                      : SvgPicture.asset(
                          "assets/images/ic_user_icon.svg",
                          color: Theme.of(context).primaryColor,
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              onTap: () {
                                questionAnswerItemBloc.add(GetProfileBridEvent(
                                    userId: widget.answer.personId,
                                    context: context));
                              },
                              child: Text(
                                widget?.answer?.inTouchPointName ??
                                    AppLocalizations.of(context).anonymous,
                                style: regularMontserrat(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AutoDirection(
                              text: widget.answer.answerBody,
                              child: Text(
                                widget.answer.answerBody,
                              ),
                            ),
                          ),
                          if (widget.answer.files.length != 0)
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
                                    'Answer files:',
                                    style: regularMontserrat(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (widget.answer.files.length != 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (widget.answer.files.length != 0)
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: ListView.builder(
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                    InkWell(
                                  onTap: () {
                                    BlocProvider.of<QuestionAnswerItemBloc>(
                                        context)
                                        .add(DownloadFileEvent(
                                        url: Urls.BASE_URL +
                                            widget.answer.files[index].url,
                                        fileName: widget
                                            .answer.files[index].name));
                                    GlobalPurposeFunctions.showToast(
                                        "the file is downloading", context);
                                  },
                                  child: DocumentFileItem(
                                      file: widget.answer.files[index],
                                      index: index,
                                      filesLength: widget.answer.files.length),
                                ),
                                itemCount: widget.answer.files.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                              ),
                            ),
                          Divider(
                            thickness: 0.5,
                            color: Colors.black38,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    var loginResponse = prefs
                                        .getString(PrefsKeys.LOGIN_RESPONSE);
                                    if (loginResponse != null)
                                      BlocProvider.of<QuestionAnswerItemBloc>(
                                          context)
                                          .add(VoteUsefulEvent(
                                        itemId: widget.answer.answerId,
                                        status: !widget.answer.markedAsUseful,
                                      ));
                                    else
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            NeedsLoginDialog(),
                                      );
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        widget.answer.markedAsUseful
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
                                        widget.answer.usefulCount.toString(),
                                        style: lightMontserrat(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    var loginResponse = prefs
                                        .getString(PrefsKeys.LOGIN_RESPONSE);
                                    if (loginResponse != null) {
                                      var response =
                                      LoginResponse.fromJson(loginResponse);
                                      if (response.userType == 0 ||
                                          response.userType == 1)
                                        BlocProvider.of<QuestionAnswerItemBloc>(
                                            context)
                                            .add(VoteEmphasisEvent(
                                          itemId: widget.answer.answerId,
                                          status:
                                          !widget.answer.markedAsEmphasis,
                                        ));
                                      else
                                        GlobalPurposeFunctions.showToast(
                                            'only health care providers can set emphasis',
                                            context);
                                    } else
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            NeedsLoginDialog(),
                                      );
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        widget.answer.markedAsEmphasis
                                            ? "assets/images/fill_favorite.svg"
                                            : "assets/images/favorite.svg",
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
                                        widget.answer.emphasisCount.toString(),
                                        style: lightMontserrat(
                                            fontSize: 14,
                                            color: Colors.black54),
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
                                      widget.answer.comments.length.toString(),
                                      style: lightMontserrat(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat.yMd('en').format(DateTime.parse(
                                      widget.answer.creationDate)),
                                  style: lightMontserrat(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
