import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {@required this.keyboardType,
      @required this.inputFormatters,
      @required this.hintText,
      @required this.controller,
      @required this.suffixIcon,
      this.onTap});
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final String hintText;
  final TextEditingController controller;
  final bool suffixIcon;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
          suffixIcon: Icon(suffixIcon ? Icons.done : Icons.close, color: Color(0xffFFCA5D)),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.4)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        cursorColor: Color(0xffFFCA5D),
        //textAlign: TextAlign.center,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xffFFCA5D),
        ),
        onTap: onTap == null ? () {} : onTap,
        minLines: 1, //Normal textInputField will be displayed
        maxLines: 5,
        controller: controller);
  }
}
