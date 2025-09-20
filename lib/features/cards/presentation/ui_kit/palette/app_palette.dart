import 'package:card_hive/core/helpers/extensions/build_context_ext.dart';
import 'package:card_hive/features/cards/presentation/ui_kit/palette/dark_palette.dart';
import 'package:card_hive/features/cards/presentation/ui_kit/palette/light_palette.dart';
import 'package:card_hive/features/cards/presentation/ui_kit/palette/palette.dart';
import 'package:flutter/material.dart';

class AppPalette {
  static Palette of(BuildContext context) =>
      context.isDarkMode ? DarkPalette() : LightPalette();
}
