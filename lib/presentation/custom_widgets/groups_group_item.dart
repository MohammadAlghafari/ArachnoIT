import 'dart:io';
import 'dart:ui';

import 'package:arachnoit/application/groups/groups_bloc.dart';
import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/pref_keys.dart';
import '../../infrastructure/api/urls.dart';
import '../../infrastructure/common_response/group_response.dart';
import '../../infrastructure/login/response/login_response.dart';
import '../../injections.dart';
import '../screens/group_details/group_details_screen.dart';

class GroupsGroupItem extends StatefulWidget {
  const GroupsGroupItem({Key key, @required this.group, this.groupsBloc})
      : super(key: key);
  final GroupsBloc groupsBloc;
  final GroupResponse group;

  @override
  _GroupsGroupItemState createState() => _GroupsGroupItemState();
}

class _GroupsGroupItemState extends State<GroupsGroupItem> {
  SharedPreferences prefs;
  String userId;

  @override
  void initState() {
    super.initState();
    prefs = serviceLocator<SharedPreferences>();
    userId = LoginResponse
        .fromJson(prefs.getString(PrefsKeys.LOGIN_RESPONSE))
        .userId;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(GroupDetailsScreen.routeName, arguments: widget.group.id)
            .then((value) {
          if (groupIdDeleted != null)
            widget.groupsBloc
                .add(DeleteGroupAndRefreshed(groupId: groupIdDeleted));
          else if (groupIdUpdated != null)
            widget.groupsBloc.add(
                UpdateGroupAndRefreshed(groupDetailsResponse: groupIdUpdated));
        });
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Card(
                  elevation: 0.0,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10, left: 10),
                        width: 60,
                        height: 60,
                        child: (widget.group.image != null &&
                                widget.group.image.url != null &&
                                widget.group.image.url != "")
                            ? ChachedNetwrokImageView(
                                isCircle: true,
                                imageUrl: widget.group.image.url,
                                showFullImageWhenClick: false,
                                function: () {
                                  Navigator.of(context)
                                      .pushNamed(GroupDetailsScreen.routeName,
                                          arguments: widget.group.id)
                                      .then((value) {
                                    if (groupIdDeleted != null)
                                      widget.groupsBloc.add(
                                          DeleteGroupAndRefreshed(
                                              groupId: groupIdDeleted));
                                    else if (groupIdUpdated != null)
                                      widget.groupsBloc.add(
                                          UpdateGroupAndRefreshed(
                                              groupDetailsResponse:
                                              groupIdUpdated));
                                  });
                                },
                              )
                            : (widget.group.image.localeImage != null &&
                                    widget.group.image.localeImage != '')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(widget.group.image.localeImage),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    "assets/images/ic_user_icon.svg",
                                    color: Theme.of(context).primaryColor,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4, right: 4),
                              child: Text(
                                widget.group.name ?? '',
                                style: semiBoldMontserrat(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Text(
                              widget.group.privacyLevel == 0
                                  ? AppLocalizations.of(context).public +
                                      '\t.\t' +
                                      widget.group.membersCount.toString() +
                                      '\t' +
                                      AppLocalizations.of(context).members
                                  : widget.group.privacyLevel == 1
                                      ? AppLocalizations.of(context).closed +
                                          '\t.\t' +
                                          widget.group.membersCount.toString() +
                                          '\t' +
                                          AppLocalizations.of(context).private
                                      : widget.group.privacyLevel == 2
                                  ?AppLocalizations
                                  .of(context)
                                  .private +
                                              '\t.\t' +
                                  widget
                                      .group.membersCount
                                      .toString() +
                                              '\t' +
                                  AppLocalizations
                                      .of(context)
                                      .private
                                          : widget.group.privacyLevel == 3
                                  ?AppLocalizations
                                  .of(context)
                                  .encoded +
                                                  '\t.\t' +
                                  widget.group.membersCount
                                      .toString() +
                                                  '\t' +
                                  AppLocalizations
                                      .of(context)
                                      .private
                                              : widget.group.privacyLevel == 4
                                                  ? 'Training\t.\t' +
                                  widget.group.membersCount
                                      .toString() +
                                                      '\t' +
                                  AppLocalizations
                                      .of(
                                      context)
                                      .private
                                                  : '',
                              style: lightMontserrat(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.group.requestStatus == 0)
                  PositionedDirectional(
                    end: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Text(
                        'Group Invitaiton',
                        style: semiBoldMontserrat(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (userId == widget.group.ownerId)
                  PositionedDirectional(
                    end: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Text(
                        AppLocalizations.of(context).creater,
                        style: semiBoldMontserrat(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            Divider(
              endIndent: 5,
              indent: 5,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
