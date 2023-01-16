import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

class RegistrationCard extends StatelessWidget {
  const RegistrationCard(
      {Key key, @required this.cardHeadline, @required this.children})
      : super(key: key);
  final String cardHeadline;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    children.insertAll(
      0,
      [
        Text(
          cardHeadline,
          style: boldMontserrat(
            color: Theme.of(context).accentColor,
            fontSize: 16,
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 2,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
