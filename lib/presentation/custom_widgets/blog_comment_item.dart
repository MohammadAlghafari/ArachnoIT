import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/custom_widgets/doctor_dialog_info.dart';
import 'package:arachnoit/presentation/custom_widgets/user_dialog_info.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/blog_comment_item/blog_comment_item_bloc.dart';
import '../../common/pref_keys.dart';
import '../../infrastructure/common_response/blog_comment_response.dart';
import '../../injections.dart';
import 'needs_login_dialog.dart';

class CommentItem extends StatefulWidget {
  CommentItem({Key key, @required this.comment}) : super(key: key);
  final CommentResponse comment;

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  CommentItemBloc commentItemBloc;

  @override
  void initState() {
    super.initState();
    commentItemBloc = serviceLocator<CommentItemBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentItemBloc>(
      create: (context) => commentItemBloc,
      child: BlocListener<CommentItemBloc, CommentItemState>(
        listener: (context, state) {
          if (state is VoteUsefulState) {
            if (widget.comment.markedAsUseful)
              widget.comment.usefulCount -= 1;
            else
              widget.comment.usefulCount += 1;
            widget.comment.markedAsUseful = !widget.comment.markedAsUseful;
          } else if (state is GetBriedProfileSuceess) {
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
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
          }
        },
        child: BlocBuilder<CommentItemBloc, CommentItemState>(
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
                        child: (widget.comment.photoUrl != null &&
                            widget.comment.photoUrl != "")
                            ? ChachedNetwrokImageView(
                          imageUrl: widget.comment.photoUrl,
                        )
                            : SvgPicture.asset(
                          "assets/images/ic_user_icon.svg",
                          color: Theme.of(context).primaryColor,
                          fit: BoxFit.cover,
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: InkWell(
                                onTap: () {
                                  commentItemBloc.add(GetProfileBridEvent(
                                      userId: widget.comment.personId,
                                      context: context));
                                },
                                child: AutoDirection(
                                  text: widget.comment.firstName +
                                      widget.comment.lastName,
                                  child: Text(
                                    widget.comment.firstName +
                                        widget.comment.lastName,
                                    style: mediumMontserrat(
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AutoDirection(
                                text: widget.comment.body,
                                child: Text(
                                  widget.comment.body,
                                ),
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
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      var loginResponse = prefs
                                          .getString(PrefsKeys.LOGIN_RESPONSE);
                                      if (loginResponse != null)
                                        BlocProvider.of<CommentItemBloc>(
                                            context)
                                            .add(VoteUsefulEvent(
                                          itemId: widget.comment.id,
                                          status:
                                          !widget.comment.markedAsUseful,
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
                                          widget.comment.markedAsUseful
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
                                          widget.comment.usefulCount.toString(),
                                          style: lightMontserrat(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Row(
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
                                          widget.comment.replies.length
                                              .toString(),
                                          style: lightMontserrat(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMd('en').format(DateTime.parse(
                                        widget.comment.creationDate)),
                                    style: lightMontserrat(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
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
          },
        ),
      ),
    );
  }
}
