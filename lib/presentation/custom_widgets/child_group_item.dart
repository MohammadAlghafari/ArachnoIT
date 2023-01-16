import 'dart:ui';

import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../infrastructure/api/urls.dart';
import '../../infrastructure/group_details/response/child_group_response.dart';
import '../../infrastructure/login/response/login_response.dart';
import '../../injections.dart';
import '../screens/group_details/group_details_screen.dart';

class ChildGroupItem extends StatefulWidget {
  const ChildGroupItem({Key key, @required this.group}) : super(key: key);

  final ChildGroupResponse group;

  @override
  _ChildGroupItemState createState() => _ChildGroupItemState();
}

class _ChildGroupItemState extends State<ChildGroupItem> {
  SharedPreferences prefs;
  String userId;

  @override
  void initState() {
    super.initState();
    prefs = serviceLocator<SharedPreferences>();
    userId = LoginResponse.fromJson(prefs.getString(PrefsKeys.LOGIN_RESPONSE))
        .userId;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(GroupDetailsScreen.routeName,
            arguments: widget.group.groupId);
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
                                imageUrl: widget.group.image.url,
                                isCircle: true,
                              )
                            : SvgPicture.asset(
                                "assets/images/ic_user_icon.svg",
                                color: Theme.of(context).primaryColor,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.group.name,
                            style: boldMontserrat(
                              fontSize: 14,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ),
                          Text(
                            widget.group.privacyLevel == 0
                                ? 'Public\t.\t' +
                                    widget.group.membersCount.toString() +
                                    '\tMembers'
                                : widget.group.privacyLevel == 1
                                    ? 'Closed\t.\t' +
                                        widget.group.membersCount.toString() +
                                        '\tMembers'
                                    : widget.group.privacyLevel == 2
                                        ? 'Private\t.\t' +
                                            widget.group.membersCount
                                                .toString() +
                                            '\tMembers'
                                        : widget.group.privacyLevel == 3
                                            ? 'Encoded\t.\t' +
                                                widget.group.membersCount
                                                    .toString() +
                                                '\tMembers'
                                            : widget.group.privacyLevel == 4
                                                ? 'Training\t.\t' +
                                                    widget.group.membersCount
                                                        .toString() +
                                                    '\tMembers'
                                                : '',
                            style: lightMontserrat(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
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
                        'Creator',
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
