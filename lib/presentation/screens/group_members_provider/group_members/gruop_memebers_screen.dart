import 'package:arachnoit/application/group_members_providers/group_invite_members/group_invite_members_bloc.dart';
import 'package:arachnoit/application/group_members_providers/group_members/group_members_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/group_members_provider/group_invite_members/gruop_invite_memebers_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../home_gruop_memebers_screen.dart';

class GroupMembersScreen extends StatefulWidget {
  final String groupId;

  const GroupMembersScreen({@required this.groupId});

  @override
  _GroupMembers createState() => new _GroupMembers();
}

class _GroupMembers extends State<GroupMembersScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController scrollController;
  RefreshController _refreshController;
  bool hasReachedMax;

  @override
  void initState() {
    super.initState();
    groupMembersBloc..add(GetGroupMembers(query: null, groupId: widget.groupId));
    scrollController = ScrollController();
    _refreshController = RefreshController();
    scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    print('AaA');
  }

  void onRefresh() async {
    groupMembersBloc.add(RefreshMemberGroupGetData(groupId: widget.groupId));
  }

  @override
  void dispose() {
    scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Color(0XFFF7F7F7),
        body: BlocProvider(
          create: (context) => groupMembersBloc,
          child: BlocListener<GroupMembersBloc, GroupMembersState>(
            listener: (context, state) {
              print(state);
              hasReachedMax = state.hasReachedMax;
              if (state.refreshMembersGroupStatus == RefreshMembersGroupStatus.success){
                print('completed');
                _refreshController.refreshCompleted();
              }

              else if (state.refreshMembersGroupStatus == RefreshMembersGroupStatus.failureValidation ||
                  state.refreshMembersGroupStatus == RefreshMembersGroupStatus.networkError ||
                  state.refreshMembersGroupStatus == RefreshMembersGroupStatus.serverError) {
                _refreshController.refreshFailed();
              }
              if (state.removeStatus == RemoveMembersFromGroupStatus.loadingData)
                GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
              else if (state.removeStatus == RemoveMembersFromGroupStatus.success) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                GlobalPurposeFunctions.showToast(AppLocalizations.of(context).success_to_remove_member, context);
                groupInviteMembersBloc.add(ChangeInviteStateMembers(personId: state.personIdRemoved));
              } else if (state.removeStatus == RemoveMembersFromGroupStatus.errorRemove) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                GlobalPurposeFunctions.showToast(AppLocalizations.of(context).error_to_remove_member, context);
              } else if (state.removeStatus == RemoveMembersFromGroupStatus.serverError) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                GlobalPurposeFunctions.showToast('server error ', context);
              } else if (state.removeStatus == RemoveMembersFromGroupStatus.networkError) {
                GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
                GlobalPurposeFunctions.showToast('network error', context);
              }
            },
            child: BlocBuilder<GroupMembersBloc, GroupMembersState>(builder: (context, state) {
              switch (state.status) {
                case GroupMembersStatus.loadingData:
                  return LoadingBloc();
                case GroupMembersStatus.success:
                  return RefreshData(
                      refreshController: _refreshController,
                      onRefresh: onRefresh,
                      body: (state.noMembersYet)
                          ?  BlocError(
                          context: context,
                          blocErrorState: BlocErrorState.noPosts,
                          function: () {
                            groupMembersBloc.add(GetGroupMembers(groupId: widget.groupId, query: null));
                          })
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: state.hasReachedMax ? state.members.length : state.members.length + 1,
                              padding: EdgeInsets.only(top: 0),
                              itemBuilder: (BuildContext context, int index) {
                                return index >= state.members.length
                                    ? BottomLoader()
                                    : Column(
                                        children: [
                                          ListTile(
                                              contentPadding: EdgeInsets.only(right: 10, left: 10),
                                              leading: (state.members[index].photo != null)
                                                  ? Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: ChachedNetwrokImageView(isCircle: true, imageUrl: state.members[index].photo),
                                                    )
                                                  : Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(image: AssetImage('assets/images/InviteMember.png'))),
                                                    ),
                                              title: Text(
                                                state.members[index].fullName ?? '',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              trailing: Wrap(
                                                children: [
                                                  RaisedButton(
                                                    onPressed: () {},
                                                    color: Color(0XFF19444C),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                                    child: Text(
                                                      (state.members[index].requestStatus == 0)
                                                          ? AppLocalizations.of(context).pending
                                                          : AppLocalizations.of(context).approved,
                                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      groupMembersBloc
                                                          .add(RemoveMemberFromGroup(groupId: widget.groupId, memberId: [state.members[index].id]));
                                                    },
                                                    color: Color(0XFFF65636),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                                    child: Text(
                                                      AppLocalizations.of(context).remove,
                                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Divider(
                                            thickness: 1,
                                          ),
                                        ],
                                      );
                              }));
                case GroupMembersStatus.failureValidation:
                  return BlocError(
                    context: context,
                      blocErrorState: BlocErrorState.unkownError,
                      function: () {
                        groupMembersBloc.add(GetGroupMembers(groupId: widget.groupId, query: null));
                      });
                case GroupMembersStatus.networkError:
                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.userError,
                      function: () {
                        groupMembersBloc.add(GetGroupMembers(groupId: widget.groupId, query: null));
                      });
                case GroupMembersStatus.serverError:
                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.serverError,
                      function: () {
                        groupMembersBloc.add(GetGroupMembers(groupId: widget.groupId, query: null));
                      });
                default:
                  return LoadingBloc();
              }
            }),
          ),
        ));
  }

  void _onScroll() {
    if (_isBottom) {
      groupMembersBloc.add(GetGroupMembers(groupId: widget.groupId, query: null));
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    if (currentScroll < 0.3) return false;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
