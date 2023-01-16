import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/screens/pending_list_department/pending_list_department.dart';
import 'package:arachnoit/presentation/screens/pending_list_group/pending_list_group.dart';
import 'package:arachnoit/presentation/screens/pending_list_patents/pending_list_patents_screen.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PendingListSceen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PendingListSceen();
  }
}

class _PendingListSceen extends State<PendingListSceen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  // ignore: must_call_super
  void didChangeDependencies() {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBarProject.showAppBar(
          title: AppLocalizations.of(context).pending_list,
          bottomWidget: TabBar(
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            labelStyle: semiBoldMontserrat(
              color: Colors.black87,
              fontSize: 15,
            ),
            onTap: (value) {},
            tabs: [
              Tab(
                text: AppLocalizations.of(context).groups,
              ),
              Tab(
                text: AppLocalizations.of(context).patents,
              ),
              Tab(
                text: AppLocalizations.of(context).department,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingListGroup(),
            PendingListPatents(),
            PendingListDepartmentView()
          ],
        ),
      ),
    );
  }
}
