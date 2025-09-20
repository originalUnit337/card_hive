import 'dart:ui';

import 'package:card_hive/features/cards/presentation/ui_kit/palette/palette.dart';
import 'package:flutter/material.dart';

class LightPalette implements Palette {
  @override
  Color get background => Color(0xFFf2f2f2);

  @override
  Color get primary => Color(0xFFcf1a3d);

  @override
  Color get appBarbackground => Colors.white54;
}
