import 'dart:ui';

class CardEntity {
  int id;
  String name;
  String? label;
  String number;
  String? logoPath;
  String? rawBarcodeSvg;
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
    this.rawBarcodeSvg,
    this.backPath,
    this.frontPath,
    this.note,
  });

  CardEntity copyWith({
    int? id,
    String? name,
    String? label,
    String? number,
    Color? color,
    String? logoPath,
    String? rawBarcodeSvg,
    String? backPath,
    String? frontPath,
    String? note,
  }) {
    return CardEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      number: number ?? this.number,
      color: color ?? this.color,
      logoPath: logoPath ?? this.logoPath,
      rawBarcodeSvg: rawBarcodeSvg ?? this.rawBarcodeSvg,
      backPath: backPath ?? this.backPath,
      frontPath: frontPath ?? this.frontPath,
      note: note ?? this.note,
    );
  }
}
