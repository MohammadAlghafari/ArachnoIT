import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:arachnoit/infrastructure/common_response/group_response.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:arachnoit/presentation/screens/group_details/group_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchGroupListItem extends StatelessWidget {
  final GroupResponse groupResponse;

  SearchGroupListItem({this.groupResponse});

  final Map<int, String> privacyLevelMap = {
    0: "Public",
    1: "Closed",
    2: "Private",
    3: "Encoded",
    4: "Training"
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GroupDetailsScreen(
                groupId: groupResponse.groupId,
              )));
        },
        leading: ChachedNetwrokImageView(
          imageUrl:
          ((groupResponse.image == null) ? "" : groupResponse.image.url),
        ),
        title: Text(
          groupResponse.name,
          style: boldMontserrat(
            fontSize: 14,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        subtitle: Text(
          "${privacyLevelMap[groupResponse.privacyLevel]}\t.\t11\t${groupResponse.membersCount}",
          style: lightMontserrat(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
