import 'package:arachnoit/infrastructure/api/urls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'cached_network_image_view.dart';

class GroupDetailsMemberImagePreviewItem extends StatelessWidget {
  const GroupDetailsMemberImagePreviewItem({Key key, @required this.imageUrl})
      : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: imageUrl != null && imageUrl != ''
          ? ChachedNetwrokImageView(
              isCircle: true,
              imageUrl:  imageUrl,
            )
          : Padding(padding: EdgeInsets.all(0)),
    );
  }
}
