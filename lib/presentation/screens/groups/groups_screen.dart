import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/common/pref_keys.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/infrastructure/login/response/login_response.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/screens/group_add/group_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/groups/groups_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/groups_group_item.dart';
import '../../custom_widgets/groups_public_group_item.dart';
import '../all_public_groups/all_public_groups_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupsScreen extends StatefulWidget {
  GroupsScreen({Key key}) : super(key: key);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final _scrollController = ScrollController();
  GroupsBloc groupsBloc;
  RefreshController _refreshController;
  List<GroupResponse> myGroups;
  LoginResponse loginResponse;
  SharedPreferences prefs;
  bool isRefrehData = false;
  void onRefresh() async {
    isRefrehData = true;
    groupsBloc.add(RefreshPublicAndMyGroupsFetchEvent());
  }

  @override
  void initState() {
    super.initState();
    prefs = serviceLocator<SharedPreferences>();
    loginResponse = LoginResponse.fromJson(prefs.getString(PrefsKeys.LOGIN_RESPONSE));
    _refreshController = RefreshController();
    _scrollController.addListener(_onScroll);
    groupsBloc = serviceLocator<GroupsBloc>();
    groupsBloc.add(PublicAndMyGroupsFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (loginResponse.userType != -1)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => AddGroupPage(
                          groupDetailsResponse: null,
                        ),
                      ),
                    )
                    .then((value) => {if (value != null) groupsBloc.add(AddGroupAndRefreshed())});
              },
              child: Icon(Icons.edit),
              heroTag: "new",
            )
          : Container(),
      body: RefreshData(
          scrollController: _scrollController,
          refreshController: _refreshController,
          onRefresh: onRefresh,
          body: BlocProvider(
            create: (context) => groupsBloc,
            child: BlocListener<GroupsBloc, GroupsState>(
              listener: (context, state) {
                print(state.status);
                print(state.groupsRefreshStatus);
                if (state.groupsRefreshStatus == RequestState.loadingData)
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
                else if (state.groupsRefreshStatus == RequestState.success) {
                  isRefrehData = false;
                  _refreshController.refreshCompleted();
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                } else if (state.groupsRefreshStatus == RequestState.serverError) {
                  isRefrehData = false;

                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                  _refreshController.refreshFailed();
                  GlobalPurposeFunctions.showToast(
                      AppLocalizations.of(context).server_error, context);
                } else if (state.groupsRefreshStatus == RequestState.networkError ||
                    state.groupsRefreshStatus == RequestState.failureValidation) {
                  isRefrehData = false;
                  GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                  GlobalPurposeFunctions.showToast(
                      AppLocalizations.of(context).check_your_internet_connection, context);
                  _refreshController.refreshFailed();
                }
              },
              child: BlocBuilder<GroupsBloc, GroupsState>(
                builder: (context, state) {
                  if (state.status == GroupsStatus.initial) return LoadingBloc();
                  return (state.status == GroupsStatus.failure)
                      ? BlocError(
                          context: context,
                          blocErrorState: BlocErrorState.userError,
                          function: () {
                            groupsBloc.add(PublicAndMyGroupsFetchEvent());
                          },
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Card(
                                  elevation: 0.0,
                                  margin: EdgeInsets.only(top: 5),
                                  child: BlocBuilder<GroupsBloc, GroupsState>(
                                      buildWhen: (previous, current) =>
                                          previous.publicGroups != current.publicGroups,
                                      builder: (context, state) {
                                        switch (state.status) {
                                          case GroupsStatus.success:
                                            if (state.publicGroups.isEmpty) {
                                              return Center(
                                                  child: Text(AppLocalizations.of(context)
                                                      .there_is_not_yet));
                                            }
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          AppLocalizations.of(context).public_group,
                                                          style: boldMontserrat(
                                                            color: Theme.of(context).accentColor,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        child: Text(
                                                          AppLocalizations.of(context).see_all,
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.visible,
                                                          style: mediumMontserrat(
                                                            color: Theme.of(context).primaryColor,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Navigator.of(context).pushNamed(
                                                              AllPublicGroupsScreen.routeName);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 150,
                                                  child: ListView.builder(
                                                    itemBuilder: (context, i) => Center(
                                                        child: GroupsPublicGroupItem(
                                                      group: state.publicGroups[i],
                                                    )),
                                                    itemCount: state.publicGroups.length,
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                  ),
                                                ),
                                              ],
                                            );
                                          default:
                                            return LoadingBloc();
                                        }
                                      })),
                              Card(
                                elevation: 0.0,
                                margin: EdgeInsets.only(top: 5),
                                child: BlocBuilder<GroupsBloc, GroupsState>(
                                    buildWhen: (before, after) => before.myGroups != after.myGroups,
                                    builder: (context, state) {
                                      switch (state.status) {
                                        case GroupsStatus.success:
                                          if (state.myGroups.isEmpty) {
                                            return Center(
                                                child: Text(
                                                    AppLocalizations.of(context).there_is_not_yet));
                                          }
                                          return Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context).my_group,
                                                      style: boldMontserrat(
                                                        color: Theme.of(context).accentColor,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                itemBuilder: (context, i) =>
                                                    i >= state.myGroups.length
                                                        ? BottomLoader()
                                                        : GroupsGroupItem(
                                                            group: state.myGroups[i],
                                                            groupsBloc: groupsBloc,
                                                          ),
                                                itemCount: state.hasReachedMax
                                                    ? state.myGroups.length
                                                    : state.myGroups.length + 1,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                              ),
                                            ],
                                          );
                                        default:
                                          return LoadingBloc();
                                      }
                                    }),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isRefrehData) groupsBloc.add(MyGroupsFetchEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
