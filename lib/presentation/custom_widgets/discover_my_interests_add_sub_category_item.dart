import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/common_response/sub_category_response.dart';

class DiscoverMyInterestsAddSubCategoryItem extends StatelessWidget {
  const DiscoverMyInterestsAddSubCategoryItem({
    Key key,
    @required this.subCategory,
    @required this.selected,
  }) : super(key: key);

  final SubCategoryResponse subCategory;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor:
      selected ?Theme
          .of(context)
          .primaryColor : Colors.grey[200],
      avatar: Icon(
        selected
            ?Icons.notifications_on_rounded
            : Icons.notifications_outlined,
        color: selected ? Colors.white : Colors.grey[500],
        size: 20,
      ),
      label: Padding(
        padding: const EdgeInsets.only(top: 3, bottom: 3, right: 4),
        child: Text(
          subCategory.name != null ? subCategory.name : '',
          style: boldMontserrat(
            color: selected ? Colors.white : Colors.grey[500],
            fontSize: 18,
          ),
          maxLines: 4,
          softWrap: true,
        ),
      ),
    );
  }
}

//Tessssss
