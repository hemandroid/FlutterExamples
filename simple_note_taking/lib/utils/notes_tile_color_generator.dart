import 'dart:math' as math;

import 'package:flutter/material.dart';

class NotesTileColorGenerator {
  static Color randomGenerator() {
    return Color((math.Random().nextDouble() * 0xFFE57373).toInt());
  }
}
