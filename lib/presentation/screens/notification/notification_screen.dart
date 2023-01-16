import 'package:arachnoit/application/main/main_bloc.dart';
import 'package:arachnoit/application/notification_provider/notification_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/notification_list_item.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen() : super();

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  RefreshController controller = RefreshController();
  NotificationBloc notificationBloc;
  bool isUpdateValue = false;
  bool successRequestBefore = false;
  MainBloc mainBloc;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    notificationBloc = serviceLocator<NotificationBloc>()
      ..add(GetUserNotificationEvent(isRefreshData: false, context: context));
    mainBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBarProject.showAppBar(
          title: AppLocalizations
              .of(context)
              .notifications,
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: TextButton(
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .read_all,
                    style: mediumMontserrat(
                      color: Theme
                          .of(context)
                          .accentColor,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () {
                    notificationBloc.add(ReadAllNotifications(
                        context: context,
                        personId:
                        GlobalPurposeFunctions
                            .getUserObject()
                            .userId));
                  },
                ),
              ),
            ),
          ]),
      body: BlocProvider<NotificationBloc>(
        create: (context) => notificationBloc,
        child: BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state.status == NotificationProviderStatus.success) {
              isUpdateValue = false;
              controller.refreshCompleted();
              successRequestBefore = true;
            } else {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              isUpdateValue = false;
              controller.refreshFailed();
            }
          },
          child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state.status == NotificationProviderStatus.loading ||
                  state.status == NotificationProviderStatus.initial) {
                if (successRequestBefore)
                  return showInfo(state);
                else
                  return LoadingBloc();
              } else if (state.status == NotificationProviderStatus.failure) {
                if (successRequestBefore)
                  return showInfo(state);
                else {
                  return BlocError(
                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      notificationBloc.add(
                        GetUserNotificationEvent(
                            isRefreshData: false, reloadData: true, context: context),
                      );
                    },
                    context: context,
                  );
                }
              } else {
                return showInfo(state);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget showInfo(NotificationState status) {
    if (status.notifications.isEmpty) {
      return BlocError(
          context: context,
          blocErrorState: BlocErrorState.noPosts,
          function: () {
            notificationBloc.add(GetUserNotificationEvent(isRefreshData: true, context: context));
          });
    }
    return Padding(
      padding: const EdgeInsets.only(top: 23.0),
      child: Scaffold(
        body: RefreshData(
          refreshController: controller,
          onRefresh: () {
            isUpdateValue = true;
            notificationBloc.add(GetUserNotificationEvent(isRefreshData: true, context: context));
          },
          body: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return index >= status.notifications.length
                  ? BottomLoader()
                  : Container(
                      child: NotificationListItem(
                        personNotification: status.notifications[index],
                        updateStatusFunction: () {
                          if(!status.notifications[index].isRead)
                          mainBloc.add(IncreaseOrDicreaseNotification(countOfIncrease: -1));
                          notificationBloc.add(
                            ReadUserNotificationEvent(
                              notificationId: <String>[
                                status.notifications[index].notificationId,
                              ],
                              selectedNotificationIndex: index,
                            ),
                          );
                        },
                      ),
                    );
            },
            itemCount: status.hasReachedMax
                ? status.notifications.length
                : status.notifications.length + 1,
            controller: _scrollController,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isUpdateValue)
      notificationBloc.add(GetUserNotificationEvent(isRefreshData: false, context: context));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  bool get wantKeepAlive => true;
}
