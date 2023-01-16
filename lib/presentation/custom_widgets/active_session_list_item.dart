import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActiveSessionListItem extends StatelessWidget {
  final bool isCurrentSession;
  final String mobileType;
  final String ipAddress;
  final Function function;

  ActiveSessionListItem({this.isCurrentSession = false,
    this.ipAddress = "",
    this.mobileType = "",
    this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          child: Padding(
            padding:
            const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  (isCurrentSession)
                      ?AppLocalizations
                      .of(context)
                      .current_session
                      : AppLocalizations
                      .of(context)
                      .active_session,
                  style: mediumMontserrat(
                      fontSize: 18, color: Theme.of(context).accentColor),
                ),
                SizedBox(height: 5),
                (isCurrentSession)
                    ? Text(
                  "HIT Android Version 1.0.18",
                  style: boldMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 15,
                  ),
                )
                    : Container(),
                (isCurrentSession) ? SizedBox(height: 6) : Container(),
                Text(
                  mobileType ?? "",
                  style: mediumMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Ip Address : ${ipAddress ?? "0"}",
                  style: mediumMontserrat(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                (!isCurrentSession)
                    ? InkWell(
                  onTap: function,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).report,
                      style: boldMontserrat(
                        color: Theme
                            .of(context)
                            .accentColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                )
                    : Container(),
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
