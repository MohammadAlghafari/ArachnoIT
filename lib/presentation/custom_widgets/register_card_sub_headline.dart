import 'package:arachnoit/common/font_style.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';

class RegisterCardSubHeadline extends StatelessWidget {
  const RegisterCardSubHeadline({Key key, @required this.text})
      : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: AutoDirection(
        text: text,
        child: Text(
          text,
          style: lightMontserrat(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
