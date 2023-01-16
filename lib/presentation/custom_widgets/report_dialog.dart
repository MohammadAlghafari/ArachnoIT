import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportDialog extends StatelessWidget {
  final LoginResponse userInfo;
  final Function reportFunction;
  TextEditingController reportController = TextEditingController();

  ReportDialog({this.userInfo, this.reportFunction, this.reportController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ChachedNetwrokImageView(
                            imageUrl: userInfo?.photoUrl ?? "",
                            height: 40,
                            width: 40,
                            isCircle: true,
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userInfo?.inTouchPointName}",
                            style: mediumMontserrat(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text("${userInfo?.specification ?? ""}",
                              style:
                              lightMontserrat(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Divider(color: Colors.grey),
                  Spacer(),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      textDirection:
                      Localizations.localeOf(context).toString() == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      textAlign:
                      Localizations.localeOf(context).toString() == 'ar'
                          ? TextAlign.right
                          : TextAlign.left,
                      controller: reportController,
                      minLines: 6,
                      autocorrect: true,
                      maxLines: 6,
                      scrollPhysics: ScrollPhysics(),
                      scrollPadding: EdgeInsets.all(5),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          fillColor: Color(0xfff2f2f2),
                          filled: true,
                          hintText: AppLocalizations
                              .of(context)
                              .write_report +
                              '.....',
                          hintStyle: mediumMontserrat(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 14,
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
                      smartDashesType: SmartDashesType.enabled,
                      smartQuotesType: SmartQuotesType.enabled,
                    ),
                  ),
                  Spacer(),
                  Divider(color: Colors.grey),
                  Spacer(),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations
                                    .of(context)
                                    .cancel,
                                style: mediumMontserrat(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          width: 1,
                          height: MediaQuery
                              .of(context)
                              .size
                              .width,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (reportController.text.trim().length > 0) {
                                reportFunction();
                              } else {
                                GlobalPurposeFunctions.showToast(
                                    AppLocalizations
                                        .of(context)
                                        .add_report_please,
                                    context);
                              }
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).submit,
                                style: mediumMontserrat(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
