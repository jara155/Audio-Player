import 'package:flutter/material.dart';

// Color primary = Barvy.Hex("f54748");
Color primary = Colors.red;

class Barvy {
  static Color Hex(String hexColor) {
    return Color(int.parse("0xff$hexColor"));
  }

  Map colors = {
    "dark": {
      "primary": Barvy.Hex("fcfcff"),
      "secondary": Barvy.Hex("909090").withOpacity(.25),
      "accent": Barvy.Hex("161616"),
      "bg": Barvy.Hex("1c2835"),
    },

    "light": {
      "primary": Barvy.Hex("060606"),
      "secondary": Barvy.Hex("747475"),
      "accent": Barvy.Hex("fafafa"),
      "bg": Barvy.Hex("dee2e5"),
    }
  };

  static Color getColorFromTheme(String type) {
    return Barvy().colors["dark"][type];
  }
}


