import 'package:card_hive/core/ui_kit/palette/palette.dart';
import 'package:flutter/material.dart';

class DarkPalette implements Palette {
  @override
  Color get background => Colors.black;

  @override
  Color get primary => const Color(0xFFcf1a3d);

  @override
  Color get appBarbackground => const Color.fromARGB(12, 158, 158, 158);
}
