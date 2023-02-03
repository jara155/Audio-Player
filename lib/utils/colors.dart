import 'package:flutter/material.dart';

// Color primary = Barvy.Hex("f54748");
Color primary = Colors.red;

Color darkPrimary = Barvy.Hex("fcfcff");
Color darkSecondary = Barvy.Hex("909090");
Color darkAccent = Barvy.Hex("161616");
Color darkBg = Barvy.Hex("1c2835");

Color lightPrimary = Barvy.Hex("060606"); // First (Text)
Color lightSecondary = Barvy.Hex("747475"); //
Color lightAccent = Barvy.Hex("fafafa");
Color lightBg = Barvy.Hex("dee2e5"); // bg

class Barvy {
  static Color Hex(String hexColor) {
    return Color(int.parse("0xff$hexColor"));
  }
}


