import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RefreshData extends StatelessWidget {
  final Widget body;
  final RefreshController refreshController;
  final Function onRefresh;
  ScrollController scrollController = ScrollController();
  RefreshData(
      {@required this.refreshController,
      @required this.body,
      @required this.onRefresh,
      this.scrollController});
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullUp: false,
        header: ClassicHeader(
          idleText: AppLocalizations.of(context).idleText,
          releaseText: AppLocalizations.of(context).releaseText,
          completeText: AppLocalizations.of(context).completeText,
          failedText: AppLocalizations.of(context).failedText,
          refreshingText: AppLocalizations.of(context).refreshingText,
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        child: body,
        scrollController: scrollController);
  }
}
