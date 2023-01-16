import 'package:arachnoit/common/font_style.dart';
import 'package:arachnoit/common/global_prupose_functions.dart';
import 'package:arachnoit/infrastructure/api/search_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvanceSearchTagsItem extends StatelessWidget {
  final SearchModel selectedTagsItem;

  AdvanceSearchTagsItem({this.selectedTagsItem});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.grey.shade400,
      avatar: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.close,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.only(top: 3, bottom: 3, right: 4),
        child: Text(
          selectedTagsItem.name,
          style: boldMontserrat(
            color: Colors.white,
            fontSize: 14,

          ),
          maxLines: 4,
          softWrap: true,
        ),
      ),
      shape: GlobalPurposeFunctions.buildButtonBorder(),
    );
  }
}
