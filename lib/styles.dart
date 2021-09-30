import 'dart:io';

import 'package:flutter/material.dart';

class Styles{
  static Color red = Colors.red[600];
  static TextStyle emphasis = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: red,
      decoration: TextDecoration.underline);
  static TextStyle normal = TextStyle(fontSize: 20);
  static const TextStyle bold =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle console = TextStyle(
    backgroundColor: Colors.black,
    fontSize: 14,
    fontFamily: Platform.isIOS ? "Courier" : "monospace",
    color: Colors.lightGreenAccent[400]
  );    
}