import 'package:flutter/material.dart';

TextStyle myTextstyle({
  double? fontSize = 16,
  FontWeight? fontWeight = FontWeight.normal,
  Color? color,
}) {
  return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
}
