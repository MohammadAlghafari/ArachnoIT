import 'package:arachnoit/application/blog_replay_item/blog_replay_item_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_comment_response.dart';
import 'package:arachnoit/infrastructure/common_response/question_answer_response.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/doctor_dialog_info.dart';
import 'package:arachnoit/presentation/custom_widgets/user_dialog_info.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../injections.dart';

class QuestionReplyCommentItem extends StatefulWidget {
  QuestionReplyCommentItem({Key key, @required this.comment, @required this.questionAnswerResponse})
      : super(key: key);
  final QuestionAnswerCommentResponse comment;
  final QuestionAnswerResponse questionAnswerResponse;
  @override
  _BlogReplyCommentItem createState() => _BlogReplyCommentItem();
}

class _BlogReplyCommentItem extends State<QuestionReplyCommentItem> {
  ReplayItemBloc replayItemBloc;
  bool isQuestionAnonymous;
  @override
  void initState() {
    super.initState();
    isQuestionAnonymous = widget?.questionAnswerResponse?.isQuestionAnonymous ?? false;
    print('dsa;lmd;alsmdl;a w2123$isQuestionAnonymous');
    replayItemBloc = serviceLocator<ReplayItemBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplayItemBloc>(
      create: (context) => replayItemBloc,
      child: BlocListener<ReplayItemBloc, ReplayItemState>(
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
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          }
        },
        child: BlocBuilder<ReplayItemBloc, ReplayItemState>(
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        child: (widget.comment.personId ==
                                    widget.questionAnswerResponse.questionOwnerId &&
                                isQuestionAnonymous)
                            ?  SvgPicture.asset(
                                "assets/images/ic_user_icon.svg",
                                color: Theme.of(context).primaryColor,
                                fit: BoxFit.cover,
                              )
                            :ChachedNetwrokImageView(
                                imageUrl: widget.comment.photoUrl,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: InkWell(
                                onTap: () {
                                  replayItemBloc.add(GetProfileBridEvent(
                                      userId: widget.comment.personId, context: context));
                                },
                                child: AutoDirection(
                                  text: widget.comment.firstName == null ||
                                          (widget.comment.personId ==
                                                  widget.questionAnswerResponse.questionOwnerId &&
                                              isQuestionAnonymous)
                                      ? AppLocalizations.of(context).anonymous
                                      : widget.comment.firstName + widget.comment.lastName,
                                  child: Text(
                                    widget.comment.firstName == null ||
                                            (widget.comment.personId ==
                                                    widget.questionAnswerResponse.questionOwnerId &&
                                                isQuestionAnonymous)
                                        ? AppLocalizations.of(context).anonymous
                                        : widget.comment.firstName + widget.comment.lastName,
                                    style: regularMontserrat(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AutoDirection(
                                text: widget.comment.body,
                                child: Text(
                                  widget.comment.body,
                                ),
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
          },
        ),
      ),
    );
  }
}
