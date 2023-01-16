import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/common_response/sub_category_response.dart';

class DiscoverCategoriesDetailsSubCategoryItem extends StatelessWidget {
  const DiscoverCategoriesDetailsSubCategoryItem({
    Key key,
    @required this.subCategory,
    @required this.selected,
  }) : super(key: key);

  final SubCategoryResponse subCategory;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).primaryColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Text(
            subCategory.name != null ? subCategory.name : '',
            style: boldMontserrat(
              color: selected ?Colors.white : Colors.grey[500],
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
