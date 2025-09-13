import 'dart:ui';

import 'package:card_hive/features/cards/presentation/ui_kit/palette/palette.dart';
import 'package:flutter/material.dart';

class AppPalette implements Palette {
  static AppPalette of(BuildContext context) => AppPalette();
  @override
  Color get background => Color(0xFFf2f2f2);
  @override
  Color get primary => Color(0xFFcf1a3d);
}
