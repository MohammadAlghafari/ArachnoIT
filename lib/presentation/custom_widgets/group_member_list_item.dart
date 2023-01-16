import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/api/urls.dart';
import '../../infrastructure/group_details/response/group_member_response.dart';

class GroupMemberListItem extends StatelessWidget {
  const GroupMemberListItem({Key key, @required this.member}) : super(key: key);

  final GroupMemberResponse member;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          width: 55,
          height: 55,
          child: Container(
            child: (member.photo != null && member.photo != "")
                ? ChachedNetwrokImageView(
              isCircle: true,
              imageUrl:  member.photo,
            )
                : SvgPicture.asset(
              "assets/images/ic_user_icon.svg",
              color: Theme.of(context).primaryColor,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          member.fullName,
          style: regularMontserrat(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
