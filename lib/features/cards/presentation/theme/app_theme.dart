import 'package:card_hive/features/cards/presentation/ui_kit/palette/dark_palette.dart';
import 'package:card_hive/features/cards/presentation/ui_kit/palette/light_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightAppTheme {
    final palette = LightPalette();
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFcf1a3d)),
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      appBarTheme: AppBarTheme(backgroundColor: palette.appBarbackground),
    );
  }

  static ThemeData get darkAppTheme {
    final palette = DarkPalette();
    return ThemeData(
      brightness: Brightness.dark,

      //colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFcf1a3d)),
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      appBarTheme: AppBarTheme(backgroundColor: palette.appBarbackground),
    );
  }
}
