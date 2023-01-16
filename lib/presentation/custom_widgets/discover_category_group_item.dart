import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/presentation/custom_widgets/cached_network_image_view.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/api/urls.dart';
import '../../infrastructure/common_response/group_response.dart';
import '../screens/group_details/group_details_screen.dart';

class DiscoverCategoryGroupItem extends StatelessWidget {
  const DiscoverCategoryGroupItem({Key key, @required this.group})
      : super(key: key);

  final GroupResponse group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(GroupDetailsScreen.routeName, arguments: group.id);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                child: Container(
                  padding: EdgeInsets.all(3),
                  width: 100,
                  height: 100,
                  child: (group.image != null &&
                      group.image.url != null &&
                      group.image.url != "")
                      ? ChachedNetwrokImageView(
                    imageUrl: group.image.url,
                    showFullImageWhenClick: false,
                    function: () {
                      Navigator.of(context).pushNamed(
                          GroupDetailsScreen.routeName,
                          arguments: group.id);
                    },
                  )
                      : SvgPicture.asset(
                    "assets/images/ic_user_icon.svg",
                    color: Theme.of(context).primaryColor,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                  child: Container(
                      width: 100,
                      child: AutoDirection(
                          text: group.name,
                          child: Text(
                            group.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: mediumMontserrat(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                            ),
                          )))),
            ],
          ),
        ),
      ),
    );
  }
}
