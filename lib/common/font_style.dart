import 'package:flutter/cupertino.dart';

boldCircular({@required double fontSize, @required Color color}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: "Circular",
    height: 1.2,
    fontWeight: FontWeight.w700,
  );
}

boldMontserrat({@required double fontSize, @required Color color}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
}

semiBoldMontserrat({@required double fontSize, @required Color color}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}

lightMontserrat({@required double fontSize, @required Color color}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
    height: 1.2,
  );
}

regularMontserrat({@required double fontSize, @required Color color}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    height: 1.2,
  );
}

mediumMontserrat({@required double fontSize, @required Color color}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
}

italicReey({@required double fontSize, @required Color color}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontFamily: "reey",
    fontWeight: FontWeight.w400,
    height: 1.2,
  );
}
