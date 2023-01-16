import 'package:arachnoit/common/font_style.dart';
import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    Key key,
    @required this.hintText,
    @required this.errorText,
    this.obscureText,
    @required this.textInputAction,
    this.handleOnChange,
    @required this.readOnly,
    this.controller,
    this.node,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);
  final String hintText;
  final String errorText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function handleOnChange;
  final bool readOnly;
  final TextEditingController controller;
  final FocusNode node;
  final TextInputType keyboardType;
  final Widget prefixIcon;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      child: TextField(
        style: regularMontserrat(
          fontSize: 13.0,
          color: Colors.black,
        ),
        cursorColor: Theme.of(context).accentColor,
        textInputAction: textInputAction,
        autofocus: false,
        focusNode: node != null ? node : null,
        obscureText: obscureText != null ? obscureText : false,
        controller: controller != null ? controller : null,
        readOnly: readOnly,
        keyboardType: keyboardType != null ? keyboardType : TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(8.0),
          hintText: hintText,
          hintStyle: lightMontserrat(
            fontSize: 13.0,
            color: Theme.of(context).primaryColor,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: suffixIcon,
          ),
          suffixIconConstraints: BoxConstraints(
            maxWidth: 25,
            maxHeight: 25,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          errorText: errorText,
          errorStyle: TextStyle(color: Colors.red),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        onChanged: handleOnChange,
      ),
    );
  }
}
