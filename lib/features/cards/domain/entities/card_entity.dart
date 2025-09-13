import 'dart:ui';

class CardEntity {
  int id;
  String name;
  String? label;
  String number;
  String? logoPath;
  String? note;
  Color color;

  CardEntity({
    required this.id,
    required this.name,
    this.label,
    required this.number,
    this.logoPath,
    this.note,
    required this.color,
  });
}
