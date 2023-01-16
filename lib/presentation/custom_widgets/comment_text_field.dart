import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentTextField extends StatefulWidget {
  final TextEditingController commentController;
  final bool isUpdateClickIcon;
  final Function sendMessage;
  final Function cancelUpdate;

  CommentTextField({
    @required this.commentController,
    @required this.isUpdateClickIcon,
    @required this.sendMessage,
    @required this.cancelUpdate,
  });

  @override
  State<StatefulWidget> createState() {
    return _CommentTextField();
  }
}

class _CommentTextField extends State<CommentTextField>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    String oldMessage = widget.commentController.text;
    if (GlobalPurposeFunctions.getUserObject() == null) return Container();
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            children: [
              AnimatedSize(
                vsync: this,
                curve: Curves.easeOut,
                duration: Duration(milliseconds: 400),
                child: Container(
                    color: Colors.white,
                    height: (widget.isUpdateClickIcon) ? 40 : 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AutoDirection(
                              text: oldMessage,
                              child: Text(
                                oldMessage,
                                style: mediumMontserrat(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: widget.cancelUpdate)
                        ],
                      ),
                    )),
              ),
              TextField(
                textInputAction: TextInputAction.done,
                textDirection:
                Localizations.localeOf(context).toString() == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlign: Localizations.localeOf(context).toString() == 'ar'
                    ? TextAlign.right
                    : TextAlign.left,
                controller: widget.commentController,
                minLines: 1,
                autocorrect: true,
                maxLines: 6,
                scrollPhysics: ScrollPhysics(),
                scrollPadding: EdgeInsets.all(5),
                decoration: InputDecoration(
                  // suffixIcon: Localizations.localeOf(context).toString() !=
                  //         'ar'
                  //     ?
                    suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (widget.commentController.text.trim().length !=
                              0) {
                            widget.sendMessage();
                          }
                        }),
                    // : null,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    fillColor: Color(0xfff2f2f2),
                    filled: true,
                    hintText: AppLocalizations.of(context).write_comment,
                    // prefixIcon: Localizations.localeOf(context).toString() ==
                    //         'ar'
                    //     ? IconButton(
                    //         icon: Icon(Icons.send),
                    //         onPressed: () {
                    //           if (widget.commentController.text.trim().length !=
                    //               0) {
                    //             widget.sendMessage();
                    //           }
                    //         })
                    //     : null,
                    hintStyle: mediumMontserrat(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontSize: 17,
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(22.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(22.0)),
                    )),
                onSubmitted: (c) =>
                (widget.commentController.text.trim().length > 0)
                    ? widget.sendMessage
                    : () {},
                smartDashesType: SmartDashesType.enabled,
                smartQuotesType: SmartQuotesType.enabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
