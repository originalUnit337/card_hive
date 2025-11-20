import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_entity.g.dart';

@JsonSerializable()
class CardEntity extends Equatable {
  int id;
  String name;
  String? label;
  String number;
  String? logoPath;
  String? rawBarcodeSvg;
  String? backPath;
  String? frontPath;
  String? note;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
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

  factory CardEntity.fromJson(Map<String, dynamic> json) =>
      _$CardEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CardEntityToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        label,
        number,
        logoPath,
        rawBarcodeSvg,
        backPath,
        frontPath,
        note,
        color,
      ];

  CardEntity copyWith({
    int? id,
    String? name,
    String? label,
    String? number,
    Color? color,
    bool logoPathSet = false,
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
      logoPath: logoPathSet ? logoPath : this.logoPath,
      rawBarcodeSvg: rawBarcodeSvg ?? this.rawBarcodeSvg,
      backPath: backPath ?? this.backPath,
      frontPath: frontPath ?? this.frontPath,
      note: note ?? this.note,
    );
  }
}

int _colorToJson(Color color) => color.value;

Color _colorFromJson(int value) => Color(value);
