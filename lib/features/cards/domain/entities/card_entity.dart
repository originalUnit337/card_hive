import 'dart:ui';

class CardEntity {
  int id;
  String name;
  String? label;
  String number;
  String? logoPath;
  String? barcodePath;
  String? backPath;
  String? frontPath;
  String? note;
  Color color;

  CardEntity({
    required this.id,
    required this.name,
    required this.number,
    required this.color,
    this.label,
    this.logoPath,
    this.barcodePath,
    this.backPath,
    this.frontPath,
    this.note,
  });
}
