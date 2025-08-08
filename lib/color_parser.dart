import 'package:flutter/material.dart';

class ColorParser {
  static const Map<String, Color> _colorMap = {
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'cyan': Colors.cyan,
    'magenta': Colors.pink,
    'white': Colors.white,
  };

  static List<Color> getSupportedColors() {
    return _colorMap.values.where((color) => color != Colors.white).toList();
  }

  static Color fromString(String colorName) {
    return _colorMap[colorName.toLowerCase()] ?? Colors.white;
  }

  static String toStringName(Color color) {
    for (final entry in _colorMap.entries) {
      if (entry.value.value == color.value) {
        return entry.key;
      }
    }
    return 'white';
  }
}