import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgPictureView extends StatelessWidget {
  String svgPath;
  double width;
  double height;
  BoxFit fit;
  Color coloSvg;
  Function function;
  Alignment alignment;
  SvgPictureView(
      {@required this.svgPath,
      this.alignment,
      this.width=10,
      this.height=10,
      this.function,
      this.fit,
      this.coloSvg=Colors.black});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: SvgPicture.asset(
        svgPath,
        height: height,
        alignment: alignment ?? Alignment.center,
        width: width,
        fit: fit ?? BoxFit.contain,
        color: coloSvg,
      ),
    );
  }
}
