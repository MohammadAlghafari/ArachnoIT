import 'package:arachnoit/application/active_session/active_session_bloc.dart';
import 'package:arachnoit/application/group_members_providers/group_invite_members/group_invite_members_bloc.dart';
import 'package:arachnoit/application/group_members_providers/group_members/group_members_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/response_type.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/group_invite_members_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_members/response/get_group_members_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/bottom_loader.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/group_members_provider/group_members/gruop_memebers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:arachnoit/presentation/custom_widgets/refresh_data.dart';

import '../home_gruop_memebers_screen.dart';
import 'dialog_add_permissions_to_invite_members_screen.dart';

class GroupInviteMembersScreen extends StatefulWidget {
  final String groupId;

  const GroupInviteMembersScreen({@required this.groupId});

  @override
  _GroupInviteMembers createState() => new _GroupInviteMembers();
}

class _GroupInviteMembers extends State<GroupInviteMembersScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _refreshController = RefreshController(initialRefresh: false);
    groupInviteMembersBloc..add(GetGroupInviteMembers(query: null, groupId: widget.groupId));
  }

  GetGroupMembersResponse membersResponse;

  List<bool> isInvited;

  void _onRefresh() async {
    groupInviteMembersBloc.add(RefreshMemberInviteGetData(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocProvider(
          create: (context) => groupInviteMembersBloc,
          child: BlocListener<GroupInviteMembersBloc, GroupInviteMembersState>(listener: (context, state) {
            if (state.status == RequestState.success) {
              isInvited = state.isInvited.values.toList();
            }
            if (state.refreshGroupInviteMembersStatus == RequestState.success)
              _refreshController.refreshCompleted();
            else if (state.refreshGroupInviteMembersStatus == RequestState.failureValidation ||
                state.refreshGroupInviteMembersStatus == RequestState.serverError ||
                state.refreshGroupInviteMembersStatus == RequestState.networkError)
              _refreshController.refreshFailed();
            if (state.inviteMemberStatus == RequestState.loadingData)
              GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
            else if (state.inviteMemberStatus == RequestState.success) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast(AppLocalizations.of(context).success_to_invite_member, context);
              // groupMembersBloc..add(ReloadGetGroupMembers(membersResponse:membersResponse));
              // groupMembersBloc..add(RefeachMember());
            } else if (state.inviteMemberStatus == RequestState.failureValidation) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast(AppLocalizations.of(context).error_to_invite_member, context);
            } else if (state.inviteMemberStatus == RequestState.serverError) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast('server error ', context);
            } else if (state.inviteMemberStatus == RequestState.networkError) {
              GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
              GlobalPurposeFunctions.showToast('network error', context);
            }
          }, child: BlocBuilder<GroupInviteMembersBloc, GroupInviteMembersState>(
              // buildWhen: (previous ,current)=> previous.isInvited==current.isInvited,
              builder: (context, state) {
            switch (state.status) {
              case RequestState.loadingData:
                return LoadingBloc();
              case RequestState.success:
                if (state.members.isEmpty) {
                  return BlocError(
                      context: context,
                      blocErrorState: BlocErrorState.noPosts,
                      function: () {
                        groupInviteMembersBloc.add(GetGroupInviteMembers(groupId: widget.groupId, query: null));
                      });
                }
                return RefreshData(
                    refreshController: _refreshController,
                    onRefresh: _onRefresh,
                    body: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.hasReachedMax ? state.members.length : state.members.length + 1,
                        padding: EdgeInsets.only(top: 10),
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
                                  trailing: Container(
                                      child: (isInvited[index])
                                          ? Wrap(
                                        children: [
                                          RaisedButton(
                                            onPressed: () {},
                                            color: Color(0XFF19444C),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                            child: Text(
                                              AppLocalizations.of(context).pending,
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              groupMembersBloc.add(
                                                  RemoveMemberFromGroup(groupId: widget.groupId, memberId: [state.members[index].id]));
                                            },
                                            color: Color(0XFFF65636),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                            child: Text(
                                              AppLocalizations.of(context).remove,
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      )
                                          : Wrap(
                                        children: [
                                          RaisedButton(
                                            onPressed: () {
                                              showDialog(
                                                barrierDismissible: false,
                                                useRootNavigator: true,
                                                context: context,
                                                builder: (context) => DialogGroupInviteMembersScreen(
                                                  membersResponse: state.members[index],
                                                ),
                                              ).then((value) {
                                                if (value != null)
                                                  groupInviteMembersBloc.add(InviteMembersToGroup(
                                                      memberInvitePermissionType: value.memberInvitePermissionType,
                                                      groupPermission: value.groupPermissionResponse,
                                                      groupId: widget.groupId,
                                                      personId: state.members[index].id));
                                                membersResponse = GetGroupMembersResponse(
                                                    accountType: state.members[index].accountType,
                                                    archiveStatus: state.members[index].archiveStatus,
                                                    firstName: state.members[index].firstName,
                                                    fullName: state.members[index].fullName,
                                                    id: state.members[index].id,
                                                    inTouchPointName: state.members[index].inTouchPointName,
                                                    isHealthcareProvider: state.members[index].isHealthcareProvider,
                                                    isValid: state.members[index].isValid,
                                                    lastName: state.members[index].lastName,
                                                    photo: state.members[index].photo,
                                                    profileType: state.members[index].profileType,
                                                    requestStatus: (state.members[index].requestStatus) ?? 0);
                                              });
                                            },
                                            color: Color(0XFF19444C),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                                            child: Text(
                                              AppLocalizations.of(context).invite,
                                              style: TextStyle(color: Colors.white, fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ))),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          );
                        }));

              case RequestState.failureValidation:
                return BlocError(
                  context: context,
                    blocErrorState: BlocErrorState.unkownError,
                    function: () {
                      groupInviteMembersBloc.add(GetGroupInviteMembers(groupId: widget.groupId, query: null));
                    });
              case RequestState.networkError:
                return BlocError(
                    context: context,

                    blocErrorState: BlocErrorState.userError,
                    function: () {
                      groupInviteMembersBloc.add(GetGroupInviteMembers(groupId: widget.groupId, query: null));
                    });
              case RequestState.serverError:
                return BlocError(
                    context: context,

                    blocErrorState: BlocErrorState.serverError,
                    function: () {
                      groupInviteMembersBloc.add(GetGroupInviteMembers(groupId: widget.groupId, query: null));
                    });
              default:
                return LoadingBloc();
            }
          }))),
    );
  }

  void _onScroll() {
    if (_isBottom) groupInviteMembersBloc.add(GetGroupInviteMembers(groupId: widget.groupId, query: null));
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll < 0.9) return false;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
