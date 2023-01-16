import 'package:arachnoit/domain/pending_item/pending_item.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'cached_network_image_view.dart';

class PendingListItem extends StatelessWidget {
  final PendingItem pendingItemContaint;
  final Function leaveFunction;
  final Function acceptInovationFuncation;
  final Function navigatorFunction;
  PendingListItem(
      {this.pendingItemContaint,
      this.leaveFunction,
      this.acceptInovationFuncation,
      this.navigatorFunction});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ChachedNetwrokImageView(
                  imageUrl: pendingItemContaint.imageUrl == null
                      ? ""
                      : pendingItemContaint.imageUrl,
                  isCircle: true,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              pendingItemContaint.name,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: navigatorFunction,
                            child: Icon(
                              Icons.exit_to_app,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: AutoDirection(
                          text: "مرحبا",
                          child: Text(
                            pendingItemContaint.description,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 0.8,
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (pendingItemContaint.requestStatus == 1)
                      ? "${AppLocalizations.of(context).status}: ${AppLocalizations.of(context).approved}"
                      : "${AppLocalizations.of(context).status}: ${AppLocalizations.of(context).pending_approval}",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: leaveFunction,
                      child: Text(
                        AppLocalizations.of(context).leave,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(width: 8),
                    (pendingItemContaint.requestStatus == 0)
                        ? InkWell(
                            onTap: acceptInovationFuncation,
                            child: Text(
                             AppLocalizations.of(context).accept,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
