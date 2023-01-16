import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

class RegistrationHeadline extends StatelessWidget {
  const RegistrationHeadline({Key key,@required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Text(
          text,
          style: boldMontserrat(
            color: Theme.of(context).accentColor,
            fontSize: 20,

          ),
        ),
      ),
    );
  }
}