import 'package:arachnoit/common/check_permissions.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/app_bar.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../infrastructure/group_details/response/group_details_response.dart';
import '../../../infrastructure/group_details/response/group_member_response.dart';
import '../../custom_widgets/child_group_item.dart';
import '../../custom_widgets/group_member_list_item.dart';

class GroupDetailsInfoScreen extends StatelessWidget {
  static const routeName = '/group_details_info_screen';
  const GroupDetailsInfoScreen({Key key, @required this.groupDetailsResponse})
      : super(key: key);
  final GroupDetailsResponse groupDetailsResponse;
  @override
  Widget build(BuildContext context) {
    List<GroupMemberResponse> admins = [];
    List<GroupMemberResponse> members = [];
    List<GroupMemberResponse> pendingMembers = [];

    for (var i = 0; i < groupDetailsResponse.groupMembers.length; i++) {
      if (groupDetailsResponse.groupMembers[i].groupPermissions.length == 19)
        admins.add(groupDetailsResponse.groupMembers[i]);
      else if ((groupDetailsResponse.groupMembers[i].requestStatus == 0))
        pendingMembers.add(groupDetailsResponse.groupMembers[i]);
      else
        members.add(groupDetailsResponse.groupMembers[i]);
    }
    admins.add(GroupMemberResponse(
      firstName: groupDetailsResponse.owner.firstName,
      lastName: groupDetailsResponse.owner.lastName,
      fullName: groupDetailsResponse.owner.fullName,
      accountType: groupDetailsResponse.owner.accountType,
      archiveStatus: groupDetailsResponse.owner.archiveStatus,
      id: groupDetailsResponse.owner.id,
      inTouchPointName: groupDetailsResponse.owner.inTouchPointName,
      isValid: groupDetailsResponse.owner.isValid,
      isHealthcareProvider: groupDetailsResponse.owner.isHealthcareProvider,
      photo: groupDetailsResponse.owner.photo,
      profileType: groupDetailsResponse.owner.profileType,
    ));

    return Scaffold(
      appBar: AppBarProject.showAppBar(
        title: groupDetailsResponse.name,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 0.0,
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations
                          .of(context)
                          .group_description + ':',
                      style: boldMontserrat(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: AutoDirection(
                            text: groupDetailsResponse.description,
                            child: ExpandText(
                              groupDetailsResponse.description,
                              maxLines: 3,
                              style: mediumMontserrat(
                                fontSize: 15,
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                              ),
                            ))),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 0.0,
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations
                          .of(context)
                          .group_admins + ':',
                      style: boldMontserrat(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                      itemBuilder: (context, i) => GroupMemberListItem(
                        member: admins[i],
                      ),
                      itemCount: admins.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0.0,
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations
                          .of(context)
                          .group_members +
                          (groupDetailsResponse.privacyLevel != 3 ||
                                  CheckPermissions.checkInviteMemberPermission(
                                      groupDetailsResponse
                                          .loginUserGroupPermissions) ||
                                  CheckPermissions.checkDisplayNamesPermission(
                                      groupDetailsResponse
                                          .loginUserGroupPermissions)
                              ? ':'
                              : ' (${members.length})'),
                      style: boldMontserrat(
                        color: Theme.of(context).accentColor,
                        fontSize: 16,

                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (groupDetailsResponse.privacyLevel != 3 ||
                        CheckPermissions.checkInviteMemberPermission(
                            groupDetailsResponse.loginUserGroupPermissions) ||
                        CheckPermissions.checkDisplayNamesPermission(
                            groupDetailsResponse.loginUserGroupPermissions))
                      ListView.builder(
                        itemBuilder: (context, i) => GroupMemberListItem(
                          member: members[i],
                        ),
                        itemCount: members.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                  ],
                ),
              ),
            ),
            if (pendingMembers != null &&
                pendingMembers.length != 0 &&
                (CheckPermissions.checkInviteMemberPermission(
                        groupDetailsResponse.loginUserGroupPermissions) ||
                    CheckPermissions.checkDisplayNamesPermission(
                        groupDetailsResponse.loginUserGroupPermissions)))
              Card(
                elevation: 0.0,
                margin: EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations
                            .of(context)
                            .group_pending_members,
                        style: boldMontserrat(
                          color: Theme.of(context).accentColor,
                          fontSize: 16,

                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                        itemBuilder: (context, i) => GroupMemberListItem(
                          member: pendingMembers[i],
                        ),
                        itemCount: pendingMembers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                ),
              ),
            if (groupDetailsResponse.childrenGroup != null &&
                groupDetailsResponse.childrenGroup.length != 0)
              Card(
                elevation: 0.0,
                margin: EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppLocalizations
                            .of(context)
                            .sub_group + ":",
                        style: boldMontserrat(
                          color: Theme.of(context).accentColor,
                          fontSize: 16,

                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                        itemBuilder: (context, i) => ChildGroupItem(
                          group: groupDetailsResponse.childrenGroup[i],
                        ),
                        itemCount: groupDetailsResponse.childrenGroup.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
