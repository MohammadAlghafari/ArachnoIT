import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

class DropDownTextField extends StatelessWidget {
  const DropDownTextField({Key key, @required this.hintText,@required this.errorText, @required this.handleTap,this.controller,this.node,this.color})
      : super(key: key);
  final String hintText;
  final String errorText;
  final Function handleTap;
  final TextEditingController controller;
  final FocusNode node;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 7,),
        child: TextField(
          readOnly: true,
          controller: controller,
          focusNode: node,
          autofocus: false,
          style: lightMontserrat(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 16, top:25 ,),
            isDense: true,
            hintText: hintText,
            hintStyle: lightMontserrat(
              fontSize: 14,
              color: Colors.black,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Icon(
                Icons.arrow_drop_down,
                size: 22,
                color: color??Theme.of(context).primaryColor,
              ),
            ),
            errorText: errorText,
            errorStyle: TextStyle(color:  color??Colors.red),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:  color??Colors.red),
            ),
          ),

          onTap: handleTap,
        ));
  }
}
