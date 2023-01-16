import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/user_manual/user_manual_bloc.dart';
import '../../../common/global_prupose_functions.dart';
import '../../../infrastructure/api/urls.dart';
import '../../../injections.dart';

class UserManualScreen extends StatefulWidget {
  static const routeName = '/user_manual_screen';

  const UserManualScreen({Key key}) : super(key: key);

  @override
  _UserManualScreenState createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  UserManualBloc userManualBloc;

  @override
  void initState() {
    super.initState();
    userManualBloc = serviceLocator<UserManualBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: AppLocalizations.of(context).user_manual,
      ),
      body: Card(
        elevation: 0.0,
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocProvider(
            create: (context) => userManualBloc,
            child: BlocListener<UserManualBloc, UserManualState>(
              listener: (context, state) {
                if (state is FileDownloadedState)
                  GlobalPurposeFunctions.showToast("file downloaded", context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context).user_manual,
                    textAlign: TextAlign.center,
                    style: boldCircular(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).accentColor,
                    thickness: 4,
                    endIndent: MediaQuery.of(context).size.width / 3,
                    indent: MediaQuery.of(context).size.width / 3,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .you_can_download_the_user_manual_and_specification_platform_from_here,
                    textAlign: TextAlign.start,
                    style: boldCircular(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<UserManualBloc, UserManualState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<UserManualBloc>(context).add(
                              DownloadFileEvent(
                                  url: Urls.USER_MANUAL,
                                  fileName: 'manual.pdf',
                                  context: context));
                          GlobalPurposeFunctions.showToast(
                              "the file is downloading", context);
                        },
                        child: Text(
                          AppLocalizations.of(context).user_manual,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<UserManualBloc, UserManualState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<UserManualBloc>(context).add(
                              DownloadFileEvent(
                                  url: Urls.SPECIFICATION_PLATFORM,
                                  fileName: 'specification.pdf',
                                  context: context));
                          GlobalPurposeFunctions.showToast(
                              "the file is downloading", context);
                        },
                        child: Text(
                          AppLocalizations.of(context).specification_platform,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
