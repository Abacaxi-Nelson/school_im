import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {@required this.label,
      @required this.onPressed,
      @required this.color,
      @required this.color2,
      @required this.borderColor});
  final GestureTapCallback onPressed;
  final String label;
  final Color color;
  final Color color2;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 0.0,
      padding: const EdgeInsets.all(14.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: borderColor, width: 5.0)),
      onPressed: onPressed,
      color: color,
      textColor: color2,
      child: Text(label, style: TextStyle(fontSize: 14)),
    );
  }
}
