import 'package:arachnoit/application/group_members_providers/group_permission/group_permission_bloc.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/group_details/response/group_permission_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_invite_members/response/group_invite_members_response.dart';
import 'package:arachnoit/infrastructure/group_members_providers/group_permission/response/group_permission_response.dart';
import 'package:arachnoit/injections.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_error.dart';
import 'package:arachnoit/presentation/custom_widgets/bloc_loading.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogGroupInviteMembersScreen extends StatefulWidget {
  final GetGroupInviteMembersResponse membersResponse;

  const DialogGroupInviteMembersScreen({@required this.membersResponse});

  @override
  _DialogGroupInviteMembers createState() => new _DialogGroupInviteMembers();
}

class ParamToInvite {
  final MemberInvitePermissionType memberInvitePermissionType;
  final List<GroupPermission> groupPermissionResponse;

  const ParamToInvite({@required this.memberInvitePermissionType, @required this.groupPermissionResponse});
}

class _DialogGroupInviteMembers extends State<DialogGroupInviteMembersScreen> with TickerProviderStateMixin {
  GroupPermissionBloc groupPermissionBloc;

  @override
  void initState() {
    super.initState();
    groupPermissionBloc = serviceLocator<GroupPermissionBloc>()..add(GetGroupPermission());
    if (widget.membersResponse.accountType == -1)
      groupPermissionBloc..add(ChangeMemberPermissionType(memberInvitePermissionType: MemberInvitePermissionType.User));
  }
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
            child: BlocProvider(
                create: (context) => groupPermissionBloc,
                child: BlocListener<GroupPermissionBloc, GroupPermissionState>(
                    listener: (context, state) {},
                    child: BlocBuilder<GroupPermissionBloc, GroupPermissionState>(builder: (context, state) {
                      switch (state.groupPermissionStatus) {
                        case GroupPermissionStatus.loadingData:
                          return LoadingBloc();
                        case GroupPermissionStatus.success:
                          if (state.groupPermission.isEmpty) {
                            return BlocError(
                                context: context,
                                blocErrorState: BlocErrorState.noPosts,
                                function: () {
                                  groupPermissionBloc.add(GetGroupPermission());
                                });
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                         // set this to false initially


                              Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Color(0XFF19444C),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                                child: Center(
                                  child: Text(
                                 AppLocalizations.of(context).add_permission,
                                    style: TextStyle(color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 25,
                                        ),

                                        (widget.membersResponse.photo != null)
                                            ? Container(
                                                child: ChachedNetwrokImageView(
                                                    height: 80, width: 80, isCircle: true, imageUrl: widget.membersResponse.photo),
                                              )
                                            : Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(image: AssetImage('assets/images/InviteMember.png'))),
                                              ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          widget.membersResponse.fullName ?? '',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),



                                        RadioListTile(
                                          value: MemberInvitePermissionType.Admin,
                                          groupValue: state.memberInvitePermissionType,
                                          onChanged: (value) {
                                            if (widget.membersResponse.profileType != -1)
                                              groupPermissionBloc
                                                ..add(ChangeMemberPermissionType(memberInvitePermissionType: MemberInvitePermissionType.Admin));
                                          },
                                          title: Text(
                                            AppLocalizations.of(context).admin,

                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                          ),
                                          subtitle:   Text(
                                            AppLocalizations.of(context).admin_permissions,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        RadioListTile(
                                          value: MemberInvitePermissionType.Editor,
                                          groupValue: state.memberInvitePermissionType,
                                          onChanged: (value) {
                                            if (widget.membersResponse.profileType != -1)
                                              groupPermissionBloc
                                                ..add(ChangeMemberPermissionType(memberInvitePermissionType: MemberInvitePermissionType.Editor));
                                          },
                                          selected: false,
                                          title: Text(
                                            AppLocalizations.of(context).editor,

                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                          ),
                                          subtitle:   Text(
                                            AppLocalizations.of(context).editor_permissions,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        RadioListTile(
                                          value: MemberInvitePermissionType.Coordinator,
                                          groupValue: state.memberInvitePermissionType,
                                          onChanged: (value) {
                                            if (widget.membersResponse.profileType != -1)
                                              groupPermissionBloc
                                                ..add(ChangeMemberPermissionType(memberInvitePermissionType: MemberInvitePermissionType.Coordinator));
                                          },
                                          selected: false,
                                          title: Text(
                                            AppLocalizations.of(context).coordinator,

                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                          ),
                                          subtitle:   Text(
                                            AppLocalizations.of(context).coordinator_permissions,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        RadioListTile(
                                          toggleable: false,
                                          dense: false,
                                          value: MemberInvitePermissionType.User,
                                          groupValue: state.memberInvitePermissionType,
                                          onChanged: (value) {
                                            if (widget.membersResponse.profileType != -1)
                                              groupPermissionBloc
                                                ..add(ChangeMemberPermissionType(memberInvitePermissionType: MemberInvitePermissionType.User));
                                          },
                                          selected: false,
                                          title: Text(
                                            AppLocalizations.of(context).user,

                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                          ),
                                          subtitle:   Text(
                                            AppLocalizations.of(context).user_permissions,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 60,
                                                child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    shape: new RoundedRectangleBorder(
                                                        borderRadius: new BorderRadius.circular(00.0),
                                                        side: BorderSide(width: 0.5, color: Colors.grey)),
                                                    child: Center(
                                                      child: Text(
                                                        AppLocalizations.of(context).cancel,

                                                        style: TextStyle(fontSize: 18, color: Color(0XFFF76B4F)),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 60,
                                                child: FlatButton(
                                                  onPressed: () {
                                                   if(state.memberInvitePermissionType!=null)
                                                    Navigator.pop(
                                                        context,
                                                        ParamToInvite(
                                                            memberInvitePermissionType: state.memberInvitePermissionType,
                                                            groupPermissionResponse: state.groupPermission));
                                                            else GlobalPurposeFunctions.showToast(AppLocalizations.of(context).please_check_member_type, context);
                                                  },
                                                  shape: new RoundedRectangleBorder(
                                                      borderRadius: new BorderRadius.circular(00.0),
                                                      side: BorderSide(width: 0.5, color: Colors.grey)),
                                                  child: Center(
                                                      child: Text(
                                                        AppLocalizations.of(context).submit,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0XFFF76B4F),
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        case GroupPermissionStatus.failureValidation:
                          return BlocError(
                            context: context,
                              blocErrorState: BlocErrorState.unkownError,
                              function: () {
                                groupPermissionBloc.add(GetGroupPermission());
                              });
                        case GroupPermissionStatus.networkError:
                          return BlocError(
                              context: context,
                              blocErrorState: BlocErrorState.userError,
                              function: () {
                                groupPermissionBloc.add(GetGroupPermission());
                              });
                        case GroupPermissionStatus.serverError:
                          return BlocError(
                               context: context,
                              blocErrorState: BlocErrorState.serverError,
                              function: () {
                                groupPermissionBloc.add(GetGroupPermission());
                              });
                        default:
                          return LoadingBloc();
                      }
                    })))));
  }
}
