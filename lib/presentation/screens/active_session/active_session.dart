import 'package:arachnoit/application/active_session/active_session_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/active_session/response/active_session_model.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/active_session_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/report_dialog.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActiveSession extends StatefulWidget {
  final AndroidDeviceInfo mobileInfo;
  final String wifiIP;
  ActiveSession({this.wifiIP, this.mobileInfo});
  @override
  State<StatefulWidget> createState() {
    return _ActiveSession();
  }
}

class _ActiveSession extends State<ActiveSession> {
  TextEditingController _controller = TextEditingController();
  ActiveSessionBloc activeSessionBloc;
  List<ActiveSessionModel> activeSessionModel = [];
  bool successRequestBefore = false;
  @override
  void initState() {
    super.initState();
    activeSessionBloc = serviceLocator<ActiveSessionBloc>();
    activeSessionBloc.add(GetALlActiveSessionEvent());
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: AppLocalizations.of(context).active_session,
      ),
      body: BlocProvider<ActiveSessionBloc>(
        create: (context) => activeSessionBloc,
        child: BlocListener<ActiveSessionBloc, ActiveSessionState>(
          listener: (context, state) {
            if (state is GelAllActiveSessionSuccess) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
            if (state is GelAllActiveSessionSuccess) {
              successRequestBefore = true;
              activeSessionModel = state.activeSeeions;
            } else if (state is LoadingSendReport) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            } else if (state is SendReportSuccess) {
              GlobalPurposeFunctions.showToast(
                state.message,
                context,
              );
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              Navigator.pop(context);
            } else if (state is FailedSendReport) {
              GlobalPurposeFunctions.showToast(
                state.message,
                context,
              );
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            }
          },
          child: BlocBuilder<ActiveSessionBloc, ActiveSessionState>(
            builder: (context, state) {
              if (successRequestBefore) return showInfo();
              if (state is LoadingState) {
                return LoadingBloc();
              } else if (state is RemoteValidationErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.validationError,
                  function: () {
                    activeSessionBloc.add(GetALlActiveSessionEvent());
                  },
                );
              } else if (state is RemoteServerErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.serverError,
                  function: () {
                    activeSessionBloc.add(GetALlActiveSessionEvent());
                  },
                );
              } else if (state is RemoteClientErrorState) {
                return BlocError(
                  context: context,
                  blocErrorState: BlocErrorState.userError,
                  function: () {
                    activeSessionBloc.add(GetALlActiveSessionEvent());
                  },
                );
              }
              return showInfo();
            },
          ),
        ),
      ),
    );
  }

  final refreshController = RefreshController();
  Widget showInfo() {
    if (activeSessionModel.length == 0)
      return Container();
    else
      return RefreshData(
        onRefresh: () {
          activeSessionBloc.add(GetALlActiveSessionEvent(isRefreshData: true));
        },
        refreshController: refreshController,
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            ActiveSessionListItem(
              isCurrentSession: true,
              ipAddress: widget.wifiIP,
              mobileType: widget.mobileInfo.model +
                  " , " +
                  "Android " +
                  widget.mobileInfo.version.release +
                  " ( " +
                  widget.mobileInfo.version.sdkInt.toString() +
                  " ) ",
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return ActiveSessionListItem(
                  isCurrentSession: false,
                  function: () async {
                    _controller.text = "";
                    showDialog(
                      context: context,
                      builder: (context) => ReportDialog(
                        userInfo: GlobalPurposeFunctions.getUserObject(),
                        reportFunction: () {
                          activeSessionBloc.add(SendReportEvent(
                              context: context,
                              itemId: activeSessionModel[index].id,
                              message: _controller.text));
                        },
                        reportController: _controller,
                      ),
                    );
                  },
                  ipAddress: activeSessionModel[index].ip,
                  mobileType: activeSessionModel[index].product +
                      " " +
                      activeSessionModel[index].model +
                      " , Android API " +
                      " ( " +
                      activeSessionModel[index].osApiLevel.toString() +
                      " ) ",
                );
              },
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: activeSessionModel.length,
            )
          ],
        ),
      );
  }
}
