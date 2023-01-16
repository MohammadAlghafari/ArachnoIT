import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

class PostTagItem extends StatelessWidget {
  const PostTagItem({Key key, @required this.tagName}) : super(key: key);
  final String tagName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.zero,
            bottomRight: Radius.circular(20)),
      ),
      child: Text(
        tagName,
        style: semiBoldMontserrat(
          color: Colors.white,

          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
